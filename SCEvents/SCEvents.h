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
    id <SCEventListenerProtocol> _delegate;
    
    BOOL _isWatchingPaths;
    FSEventStreamRef _eventStream;
    CFTimeInterval _notificationLatency;
    
    SCEvent *_lastEvent;
    NSMutableArray *_watchedPaths;
}

+ (id)sharedPathWatcher;

- (id)delegate;
- (void)setDelegate:(id)delgate;

- (BOOL)isWatchingPaths;

- (SCEvent *)lastEvent;
- (void)setLastEvent:(SCEvent *)event;

- (double)notificationLatency;
- (void)setNotificationLatency:(double)latency;

- (NSMutableArray *)watchedPaths;
- (void)setWatchedPaths:(NSMutableArray *)paths;

- (BOOL)flushEventStreamSync;
- (BOOL)flushEventStreamAsync;

- (BOOL)startWatchingPaths:(NSMutableArray *)paths;
- (BOOL)startWatchingPaths:(NSMutableArray *)paths onRunLoop:(NSRunLoop *)runLoop;

- (BOOL)stopWatchingPaths;

@end