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

@class SCEvents, SCEvent;

@protocol SCEventListenerProtocol

// -------------------------------------------------------------------------------
// pathWatcher:eventOccurred:
//
// Conforming objects implementation of this method will be called whenever an
// event occurs. The instance of SCEvents which received the event and the event
// itself are passed as parameters.
// -------------------------------------------------------------------------------
- (void)pathWatcher:(SCEvents *)pathWatcher eventOccurred:(SCEvent *)event;

@end