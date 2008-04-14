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
#import "Controller.h"

int main(int argc, const char *argv[]) 
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    Controller *controller = [[[Controller alloc] init] autorelease];
    
    [controller setupEventlistener];
    
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:120.0]];
    
    [pool release];
    
    return 0;
}