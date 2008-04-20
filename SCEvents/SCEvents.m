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
static void _SCEventsCallBack(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[]);

@end

static SCEvents *_sharedPathWatcher = nil;

@implementation SCEvents

// -------------------------------------------------------------------------------
// sharedPathWatcher
//
// Returns the shared singleton instance of SCEvents.
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
// Initializes an instance of SCEvents setting its default values.
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
// Restuns SCEvents' delegate.
// -------------------------------------------------------------------------------
- (id)delegate
{
    return _delegate;
}

// -------------------------------------------------------------------------------
// setDelegate:
//
// Sets SCEvents' delegate to the supplied object. This object should conform to 
// the protocol SCEventListernerProtocol.
// -------------------------------------------------------------------------------
- (void)setDelegate:(id)delgate
{
    _delegate = delgate;
}

// -------------------------------------------------------------------------------
// isWatchingPaths
//
// Returns a boolean value indicating whether or not the set paths are currently 
// being watched (i.e. the event stream is currently running).
// -------------------------------------------------------------------------------
- (BOOL)isWatchingPaths
{
    return _isWatchingPaths;
}

// -------------------------------------------------------------------------------
// lastEvent
//
// Returns the last event that occurred. This method is supposed to replicate the
// FSEvents API function FSEventStreamGetLatestEventId but also returns the event
// path and flag in the form of an instance of SCEvent.
// -------------------------------------------------------------------------------
- (SCEvent *)lastEvent
{
    return _lastEvent;
}

// -------------------------------------------------------------------------------
// setLastEvent:
//
// Sets the last event that occurred to the supplied event.
// -------------------------------------------------------------------------------
- (void)setLastEvent:(SCEvent *)event
{
    if (_lastEvent != event) {
        [_lastEvent release];
        _lastEvent = [event retain];
    }
}

// -------------------------------------------------------------------------------
// notificationLatency
//
// Returns the event notification latency in seconds.
// -------------------------------------------------------------------------------
- (double)notificationLatency
{
    return _notificationLatency;
}

// -------------------------------------------------------------------------------
// setNotificationLatency
//
// Sets the event notification latency to the supplied latency in seconds.
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
// Returns the array of watched paths.
// -------------------------------------------------------------------------------
- (NSMutableArray *)watchedPaths
{
    return _watchedPaths;
}

// -------------------------------------------------------------------------------
// setWatchedPaths:
//
// Sets the watched paths array to the supplied array of paths.
// -------------------------------------------------------------------------------
- (void)setWatchedPaths:(NSMutableArray *)paths
{
    if (_watchedPaths != paths) {
        [_watchedPaths release];
        _watchedPaths = [paths retain];
    }
}

// -------------------------------------------------------------------------------
// flushEventStreamSync
//
// Flushes the event stream synchronously by sending events that have already 
// occurred but not yet delivered.
// -------------------------------------------------------------------------------
- (BOOL)flushEventStreamSync
{
    if (!_isWatchingPaths) {
        return NO;
    }
    
    FSEventStreamFlushSync(_eventStream);
    
    return YES;
}

// -------------------------------------------------------------------------------
// flushEventStreamAsync
//
// Flushes the event stream asynchronously by sending events that have already 
// occurred but not yet delivered.
// -------------------------------------------------------------------------------
- (BOOL)flushEventStreamAsync
{
    if (!_isWatchingPaths) {
        return NO;
    }
    
    FSEventStreamFlushAsync(_eventStream);
    
    return YES;
}

// -------------------------------------------------------------------------------
// startWatchingPaths:
//
// Starts watching the supplied array of paths for events on the current run loop.
// -------------------------------------------------------------------------------
- (BOOL)startWatchingPaths:(NSMutableArray *)paths
{
    return [self startWatchingPaths:paths onRunLoop:[NSRunLoop currentRunLoop]];
}

// -------------------------------------------------------------------------------
// startWatchingPaths:onRunLoop:
//
// Starts watching the supplied array of paths for events on the supplied run loop.
// A boolean value is returned to indicate the success of starting the stream. If 
// there are no paths to watch or the stream is already running then false is
// returned.
// -------------------------------------------------------------------------------
- (BOOL)startWatchingPaths:(NSMutableArray *)paths onRunLoop:(NSRunLoop *)runLoop
{
    if (([paths count] == 0) || (_isWatchingPaths)) {
        return NO;
    } 
    
    [self setWatchedPaths:paths];
    [self _setupEventsStream];
    
    // Schedule the event stream on the supplied run loop
    FSEventStreamScheduleWithRunLoop(_eventStream, [runLoop getCFRunLoop], kCFRunLoopDefaultMode);
    
    // Start the event stream
    FSEventStreamStart(_eventStream);
    
    _isWatchingPaths = YES;
    
    return YES;
}

// -------------------------------------------------------------------------------
// stopWatchingPaths
//
// Stops the event stream from watching the set paths. A boolean value is returned
// to indicate the success of stopping the stream. False is return if this method 
// is called when the stream is not running.
// -------------------------------------------------------------------------------
- (BOOL)stopWatchingPaths
{
    if (!_isWatchingPaths) {
        return NO;
    }
    
    FSEventStreamStop(_eventStream);
    FSEventStreamInvalidate(_eventStream);
    
    _isWatchingPaths = NO;
    
    return YES;
}

// -------------------------------------------------------------------------------
// description
//
// Provides the string used when printing this object in NSLog, etc. Useful for
// debugging purposes.
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
    
    FSEventStreamRelease(_eventStream);
    [_watchedPaths release], _watchedPaths = nil;
    
    [super dealloc];
}

@end

@implementation SCEvents (PrivateAPI)

// -------------------------------------------------------------------------------
// _setupEventsStream
//
// Constructs the events stream.
// -------------------------------------------------------------------------------
- (void)_setupEventsStream
{
    void *callbackInfo = NULL;
    
    _eventStream = FSEventStreamCreate(kCFAllocatorDefault, &_SCEventsCallBack, callbackInfo, (CFArrayRef)_watchedPaths, kFSEventStreamEventIdSinceNow, _notificationLatency, kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagWatchRoot);
}

// -------------------------------------------------------------------------------
// _SCEventsCallBack
//
// FSEvents callback function. For each event that occurs an instance of SCEvent
// is created and passed to the delegate.
// -------------------------------------------------------------------------------
static void _SCEventsCallBack(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[])
{
    int i;
    SCEvents *pathWatcher = [SCEvents sharedPathWatcher];
    
    for (i = 0; i < numEvents; i++) {
        SCEvent *event = [SCEvent eventWithEventId:eventIds[i] eventPath:[(NSArray *)eventPaths objectAtIndex:i] eventFlag:eventFlags[i]];
                          
        if ([[pathWatcher delegate] conformsToProtocol:@protocol(SCEventListenerProtocol)]) {
            [[pathWatcher delegate] pathWatcher:pathWatcher eventOccurred:event];
        }
        
        if (i == (numEvents - 1)) {
            [pathWatcher setLastEvent:event];
        }
    }
}

@end