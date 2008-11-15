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
        [self setIgnoreEeventsFromSubDirs:YES]; 
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
// ignoreEventsFromSubDirs
//
// Returns a boolean value indicating whether or not events from sub-directories
// of the registered paths to exclude should also be ignored.
// -------------------------------------------------------------------------------
- (BOOL)ignoreEventsFromSubDirs
{
    return _ignoreEventsFromSubDirs;
}

// -------------------------------------------------------------------------------
// setIgnoreEeventsFromSubDirs:
//
// Sets whether or not events from sub-directories of the registered paths to 
// exclude should also be ignored based on the supplied values.
// -------------------------------------------------------------------------------
- (void)setIgnoreEeventsFromSubDirs:(BOOL)ignore
{
    if (_ignoreEventsFromSubDirs != ignore) {
        _ignoreEventsFromSubDirs = ignore;
    }
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
// Returns the array of paths that the client application has chosen to watch.
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
// excludedPaths
//
// Returns the array of paths that the client application has chosen to ignore
// events from.
// -------------------------------------------------------------------------------
- (NSMutableArray *)excludedPaths
{
    return _excludedPaths;
}

// -------------------------------------------------------------------------------
// setExcludedPaths:
//
// Sets the excluded paths array to the supplied array of paths.
// -------------------------------------------------------------------------------
- (void)setExcludedPaths:(NSMutableArray *)paths
{
    if (_excludedPaths != paths) {
        [_excludedPaths release];
        _excludedPaths = [paths retain];
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
    return [NSString stringWithFormat:@"<%@ { watchedPaths = %@, excludedPaths = %@ } >", [self className], _watchedPaths, _excludedPaths];
}

// -------------------------------------------------------------------------------
// dealloc
// -------------------------------------------------------------------------------
- (void)dealloc
{
    _delegate = nil;
    
    FSEventStreamRelease(_eventStream);
    
    [_watchedPaths release], _watchedPaths = nil;
    [_excludedPaths release], _excludedPaths = nil;
    
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
// is created and passed to the delegate. The frequency at which this callback is
// called depends upon the notification latency value. This callback is usually
// called with more than one event and so mutiple instances of SCEvent are created
// and the delegate notified.
// -------------------------------------------------------------------------------
static void _SCEventsCallBack(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[])
{
    int i;
    BOOL shouldIgnore = NO;
    
    SCEvents *pathWatcher = [SCEvents sharedPathWatcher];
    
    for (i = 0; i < numEvents; i++) {
        
        /* Please note that we are providing the date for when the event occurred 
         * because the FSEvents API does not provide us with it. This date however
         * should not be taken as the date the event actually occurred and more 
         * appropriatly the date for when it was delivered to this callback function.
         * Depending on what the notification latency is set to, this means that some
         * events may have very close event dates because this callback is only called 
         * once with events that occurred within the latency time.
         *
         * To get a more accurate date for when events occur, you could decrease the 
         * notification latency from its default value. This means that this callback 
         * will be called more frequently for events that just occur and reduces the
         * number of events that are subsequntly delivered during one of these calls.
         * The drawback to this approach however, is the increased resources required
         * calling this callback more frequently.
         */
        
        NSString *eventPath = [(NSArray *)eventPaths objectAtIndex:i];
        NSMutableArray *excludedPaths = [pathWatcher excludedPaths];
        
        // Check to see if the event should be ignored if the event path is in the exclude list
        if ([excludedPaths containsObject:eventPath]) {
            shouldIgnore = YES;
        }
        else {
            // If we did not find an exact match in the exclude list and we are to ignore events from
            // sub-directories then see if the exclude paths match as a prefix of the event path.
            if ([pathWatcher ignoreEventsFromSubDirs]) {
                for (NSString *path in [pathWatcher excludedPaths]) {
                    if ([[(NSArray *)eventPaths objectAtIndex:i] hasPrefix:path]) {
                        shouldIgnore = YES;
                        break;
                    }
                }
            }
        }
    
        if (!shouldIgnore) {
            NSString *eventPath = [[(NSArray *)eventPaths objectAtIndex:i] substringToIndex:([[(NSArray *)eventPaths objectAtIndex:i] length] - 1)];
            
            SCEvent *event = [SCEvent eventWithEventId:eventIds[i] eventDate:[NSDate date] eventPath:eventPath eventFlag:eventFlags[i]];
                
            if ([[pathWatcher delegate] conformsToProtocol:@protocol(SCEventListenerProtocol)]) {
                [[pathWatcher delegate] pathWatcher:pathWatcher eventOccurred:event];
            }
                
            if (i == (numEvents - 1)) {
                [pathWatcher setLastEvent:event];
            }
        }
    }
}

@end