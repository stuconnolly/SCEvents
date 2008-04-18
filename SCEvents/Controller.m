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

- (void)setupEventlistener
{
    SCEvents *events = [SCEvents sharedPathWatcher];
    
    [events setDelegate:self];
    
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    
    [paths addObject:@"/Users/stuart/"];
    
    [events startWatchingPaths:paths];
    
    NSLog(@"%@", events);
    
    [paths release];
}

- (void)pathWatcher:(SCEvents *)pathWatcher eventOccurred:(SCEvent *)event
{
    NSLog(@"Called");
}

@end