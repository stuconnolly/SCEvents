/*
 *  $Id$
 *
 *  SCEvents
 *
 *  Copyright (c) 2008 Stuart Connolly
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

@class SCEvent;
@protocol SCEventListenerProtocol;

@interface SCEvents : NSObject 
{
    id <SCEventListenerProtocol> _delegate;     // The delegate that SCEvents is to notify of events that occur.
    
    BOOL              _isWatchingPaths;         // Is the events stream currently running.
    BOOL              _ignoreEventsFromSubDirs; // Ignore events from sub-directories of the excluded paths. Defaults to YES.
    FSEventStreamRef  _eventStream;             // The actual FSEvents stream reference.
    CFTimeInterval    _notificationLatency;     // The latency time of which SCEvents is notified by FSEvents of events. Defaults to 3 seconds.
      
    SCEvent          *_lastEvent;               // The last event that occurred and that was delivered to the delegate.
    NSMutableArray   *_watchedPaths;            // The paths that are to be watched for events.
    NSMutableArray   *_excludedPaths;           // The paths that SCEvents should ignore events from and not deliver to the delegate.
}

+ (id)sharedPathWatcher;

- (id)delegate;
- (void)setDelegate:(id)delgate;

- (BOOL)isWatchingPaths;

- (BOOL)ignoreEventsFromSubDirs;
- (void)setIgnoreEeventsFromSubDirs:(BOOL)ignore;

- (SCEvent *)lastEvent;
- (void)setLastEvent:(SCEvent *)event;

- (double)notificationLatency;
- (void)setNotificationLatency:(double)latency;

- (NSMutableArray *)watchedPaths;
- (void)setWatchedPaths:(NSMutableArray *)paths;

- (NSMutableArray *)excludedPaths;
- (void)setExcludedPaths:(NSMutableArray *)paths;

- (BOOL)flushEventStreamSync;
- (BOOL)flushEventStreamAsync;

- (BOOL)startWatchingPaths:(NSMutableArray *)paths;
- (BOOL)startWatchingPaths:(NSMutableArray *)paths onRunLoop:(NSRunLoop *)runLoop;

- (BOOL)stopWatchingPaths;

@end