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

#import "Controller.h"
#import "SCEvents.h"
#import "SCEvent.h"

@implementation Controller

/**
 * Sets up the event listener using SCEvents and sets its delegate to this controller.
 * The event stream is started by calling startWatchingPaths: while passing the paths
 * to be watched.
 */
- (void)setupEventListener
{
	if (_events) return;
	
    _events = [[SCEvents alloc] init];
    
    [_events setDelegate:self];
    
    NSMutableArray *paths = [NSMutableArray arrayWithObject:NSHomeDirectory()];
    NSMutableArray *excludePaths = [NSMutableArray arrayWithObject:[NSHomeDirectory() stringByAppendingPathComponent:@"Downloads"]];
    
	// Set the paths to be excluded
	[_events setExcludedPaths:excludePaths];
	
	// Start receiving events
	[_events startWatchingPaths:paths];

	// Display a description of the stream
	NSLog(@"%@", [_events streamDescription]);	
}

/**
 * This is the only method to be implemented to conform to the SCEventListenerProtocol.
 * As this is only an example the event received is simply printed to the console.
 *
 * @param pathwatcher The SCEvents instance that received the event
 * @param event       The actual event
 */
- (void)pathWatcher:(SCEvents *)pathWatcher eventOccurred:(SCEvent *)event
{
    NSLog(@"%@", event);
}

#pragma mark -

- (void)dealloc
{
	[_events release], _events = nil;
	
	[super dealloc];
}

@end
