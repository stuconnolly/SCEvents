/*
 *  $Id$
 *
 *  SCEvents
 *  http://stuconnolly.com/projects/code/
 *
 *  Copyright (c) 2011 Stuart Connolly. All rights reserved.
 *
 *  Permission is hereby granted, free of charge, to any person
 *  obtaining a copy of this software and associated documentation
 *  files (the "Software"), to deal in the Software without
 *  restriction, including without limitation the rights to use,
 *  copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following
 *  conditions:
 *
 *  The above copyright notice and this permission notice shall be
 *  included in all copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 *  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 *  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 *  OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

#import "SCEventListenerProtocol.h"

@class SCEvent;

/**
 * @class SCEvents SCEvents.h
 *
 * @author Stuart Connolly http://stuconnolly.com/
 *
 */
@interface SCEvents : NSObject 
{
    id <SCEventListenerProtocol> _delegate;    // The delegate that SCEvents is to notify when events occur.
    
    BOOL             _isWatchingPaths;         // Is the events stream currently running.
    BOOL             _ignoreEventsFromSubDirs; // Ignore events from sub-directories of the excluded paths. Defaults to YES.
    FSEventStreamRef _eventStream;             // The actual FSEvents stream reference.
    CFTimeInterval   _notificationLatency;     // The latency time of which SCEvents is notified by FSEvents of events. Defaults to 3 seconds.
      
    SCEvent          *_lastEvent;              // The last event that occurred and that was delivered to the delegate.
    NSMutableArray   *_watchedPaths;           // The paths that are to be watched for events.
    NSMutableArray   *_excludedPaths;          // The paths that SCEvents should ignore events from and not deliver to the delegate.
}

/**
 * @property _delegate
 */
@property (readwrite, assign, getter=delegate, setter=setDelegate:) id _delegate;

/**
 * @property _isWatchingPaths
 */
@property (readonly, getter=isWatchingPaths) BOOL _isWatchingPaths;

/**
 * @property _ignoreEventsFromSubDirs
 */
@property (readwrite, assign, getter=ignoreEventsFromSubDirs, setter=setIgnoreEventsFromSubDirs:) BOOL _ignoreEventsFromSubDirs;

/**
 * @property _lastEvent
 */
@property (readwrite, retain, getter=lastEvent, setter=setLastEvent:) SCEvent *_lastEvent;

/**
 * @property _notificationLatency
 */
@property (readwrite, assign, getter=notificationLatency, setter=setNotificationLatency:) double _notificationLatency;

/**
 * @property _watchedPaths
 */
@property (readwrite, retain, getter=watchedPaths, setter=setWatchedPaths:) NSMutableArray *_watchedPaths;

/**
 * @property _excludedPaths
 */
@property (readwrite, retain, getter=excludedPaths, setter=setExcludedPaths:) NSMutableArray *_excludedPaths;

- (BOOL)flushEventStreamSync;
- (BOOL)flushEventStreamAsync;

- (BOOL)startWatchingPaths:(NSMutableArray *)paths;
- (BOOL)startWatchingPaths:(NSMutableArray *)paths onRunLoop:(NSRunLoop *)runLoop;

- (BOOL)stopWatchingPaths;

- (NSString *)streamDescription;

@end
