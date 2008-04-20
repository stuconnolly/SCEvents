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

#import "Controller.h"
#import "SCEvents.h"
#import "SCEvent.h"

@implementation Controller

// -------------------------------------------------------------------------------
// setupEventlistener
//
// Sets up the event listener using SCEvents and sets its delegate to this controller.
// The event stream is started by calling startWatchingPaths: while passing the paths
// to be watched.
// -------------------------------------------------------------------------------
- (void)setupEventlistener
{
    SCEvents *events = [SCEvents sharedPathWatcher];
    
    [events setDelegate:self];
    
    NSMutableArray *paths = [[[NSMutableArray alloc] init] autorelease];
    
    [paths addObject:@"/Users/stuart/"];
    
    [events startWatchingPaths:paths];
}

// -------------------------------------------------------------------------------
// pathWatcher:eventOccurred:
//
// This is only method to be implemented to conform to the SCEventListenerProtocol.
// As this is only an example the event received is simply printed to the console.
// -------------------------------------------------------------------------------
- (void)pathWatcher:(SCEvents *)pathWatcher eventOccurred:(SCEvent *)event
{
    NSLog(@"%@", event);
}

@end