/*
 *  $Id$
 *
 *  SCEvents
 *
 *  Copyright (c) 2008 Stuart Connolly. All rights reserved.
 * 
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
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