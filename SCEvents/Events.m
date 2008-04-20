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
    /* Please note that this program is merely an example of using the 
     * SCEvents wrapper and so the run loop created will run forever until
     * it is terminated. 
     *
     * This program's contollrer (Controller.m) simply implements the 
     * SCEventListenerProtocol and prints the returns events from SCEvents.
     * As an example, to generate some events simply run some appliacations 
     * or create/edit some files under the root directory that is being
     * watached.
     */
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    Controller *controller = [[[Controller alloc] init] autorelease];
    
    [controller setupEventlistener];
    
    [[NSRunLoop currentRunLoop] run];
    
    [pool release];
    
    return 0;
}