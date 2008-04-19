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

#import "SCEvents.h"
#import "SCEvent.h"
#import "SCEventListenerProtocol.h"

@interface SCEvents (PrivateAPI)

- (void)_setupEventsStream;
void _SCEventsCallBack(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[]);

@end

static SCEvents *_sharedPathWatcher = nil;

@implementation SCEvents

// -------------------------------------------------------------------------------
// sharedPathWatcher
//
// 
// -------------------------------------------------------------------------------
+ (id)sharedPathWatcher
{
    @synchronized(self) {
        if (_sharedPathWatcher == nil) {
            [[self alloc] init];
        }
    }
    
    return _sharedPathWatcher;
}

// -------------------------------------------------------------------------------
// allocWithZone:
//
// 
// -------------------------------------------------------------------------------
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (_sharedPathWatcher == nil) {
            _sharedPathWatcher = [super allocWithZone:zone];
            
            return _sharedPathWatcher;
        }
    }
    
    return nil; // On subsequent allocation attempts return nil
}

// -------------------------------------------------------------------------------
// init
//
// 
// -------------------------------------------------------------------------------
- (id)init
{
    if ((self = [super init])) {
        _isWatchingPaths = NO;
        
        [self setNotificationLatency:3.0];
        [self setWatchedPaths:[[NSMutableArray alloc] init]]; 
    }
    
    return self;
}

//---------------------------------------------------------------
// The following base protocol methods are implemented to ensure
// the singleton status of this class.
//--------------------------------------------------------------- 

- (id)copyWithZone:(NSZone *)zone { return self; }

- (id)retain { return self; }

- (unsigned)retainCount { return UINT_MAX; }

- (id)autorelease { return self; }

- (void)release { }

// -------------------------------------------------------------------------------
// delegate
//
// 
// -------------------------------------------------------------------------------
- (id)delegate
{
    return _delegate;
}

// -------------------------------------------------------------------------------
// setDelegate:
//
// 
// -------------------------------------------------------------------------------
- (void)setDelegate:(id)delgate
{
    _delegate = delgate;
}

// -------------------------------------------------------------------------------
// isWatchingPaths
//
// 
// -------------------------------------------------------------------------------
- (BOOL)isWatchingPaths
{
    return _isWatchingPaths;
}

// -------------------------------------------------------------------------------
// getlastEvent
//
// 
// -------------------------------------------------------------------------------
- (SCEvent *)getlastEvent
{
    return _lastEvent;
}

// -------------------------------------------------------------------------------
// notificationLatency
//
// 
// -------------------------------------------------------------------------------
- (double)notificationLatency
{
    return _notificationLatency;
}

// -------------------------------------------------------------------------------
// setNotificationLatency
//
// 
// -------------------------------------------------------------------------------
- (void)setNotificationLatency:(double)latency
{
    if (_notificationLatency != latency) {
        _notificationLatency = latency;
    }
}

// -------------------------------------------------------------------------------
// watchedPaths
//
// 
// -------------------------------------------------------------------------------
- (NSMutableArray *)watchedPaths
{
    return _watchedPaths;
}

// -------------------------------------------------------------------------------
// setWatchedPaths:
//
// 
// -------------------------------------------------------------------------------
- (void)setWatchedPaths:(NSMutableArray *)paths
{
    if (_watchedPaths != paths) {
        [_watchedPaths release];
        _watchedPaths = [paths retain];
    }
}

// -------------------------------------------------------------------------------
// flushEventStreamAsynchronously:
//
// 
// -------------------------------------------------------------------------------
- (BOOL)flushEventStreamAsynchronously:(BOOL)asynchronously
{
    
}

// -------------------------------------------------------------------------------
// startWatchingPaths:
//
// 
// -------------------------------------------------------------------------------
- (BOOL)startWatchingPaths:(NSMutableArray *)paths
{
    return [self startWatchingPaths:paths onRunLoop:[NSRunLoop currentRunLoop]];
}

// -------------------------------------------------------------------------------
// startWatchingPaths:onRunLoop:
//
// 
// -------------------------------------------------------------------------------
- (BOOL)startWatchingPaths:(NSMutableArray *)paths onRunLoop:(NSRunLoop *)runLoop
{
    if ([paths count] == 0) {
        return NO;
    } 
    
    [self setWatchedPaths:paths];
    [self _setupEventsStream];
    
    // Schedule the event stream on the supplied run loop
    FSEventStreamScheduleWithRunLoop(_eventStream, [runLoop getCFRunLoop], kCFRunLoopDefaultMode);
    
    // Start the event stream
    FSEventStreamStart(_eventStream);
    
    return YES;
}

// -------------------------------------------------------------------------------
// stopWatchingPaths:
//
// 
// -------------------------------------------------------------------------------
- (BOOL)stopWatchingPaths
{
    
}

// -------------------------------------------------------------------------------
// description
//
// 
// -------------------------------------------------------------------------------
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ { watchedPaths = %@ } >", [self className], _watchedPaths];
}

// -------------------------------------------------------------------------------
// dealloc
// -------------------------------------------------------------------------------
- (void)dealloc
{
    _delegate = nil;
    
    [_watchedPaths release], _watchedPaths = nil;
    
    [super dealloc];
}

@end

@implementation SCEvents (PrivateAPI)

// -------------------------------------------------------------------------------
// _setupEventsStream
//
// 
// -------------------------------------------------------------------------------
- (void)_setupEventsStream
{
    void *callbackInfo = NULL;
    
    _eventStream = FSEventStreamCreate(kCFAllocatorDefault, &_SCEventsCallBack, callbackInfo, (CFArrayRef)_watchedPaths, kFSEventStreamEventIdSinceNow, _notificationLatency, kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagWatchRoot);
}

// -------------------------------------------------------------------------------
// _SCEventsCallBack
//
// 
// -------------------------------------------------------------------------------
void _SCEventsCallBack(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[])
{
    int i;
    SCEvents *pathWatcher = [SCEvents sharedPathWatcher];
    
    for (i = 0; i < numEvents; i++) {
        SCEvent *event = [SCEvent eventWithEventId:eventIds[i] eventPath:[(NSArray *)eventPaths objectAtIndex:i] eventFlag:eventFlags[i]];
                          
        if ([[pathWatcher delegate] conformsToProtocol:@protocol(SCEventListenerProtocol)]) {
            [[pathWatcher delegate] pathWatcher:pathWatcher eventOccurred:event];
        }
        
        if (i == (numEvents - 1)) {
            _lastEvent = event;
        }
    }
}

@end