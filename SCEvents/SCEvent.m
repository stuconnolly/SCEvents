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

#import "SCEvent.h"

@implementation SCEvent

// -------------------------------------------------------------------------------
// eventId
//
// Returns the event ID of this event.
// -------------------------------------------------------------------------------
- (NSUInteger)eventId
{
    return _eventId;
}

// -------------------------------------------------------------------------------
// setEventId:
//
// Sets the event ID of this event to the supplied ID.
// -------------------------------------------------------------------------------
- (void)setEventId:(NSUInteger)eventId
{
    if (_eventId != eventId) {
        _eventId = eventId;
    }
}

// -------------------------------------------------------------------------------
// eventPath
//
// Returns the event path of this event.
// -------------------------------------------------------------------------------
- (NSString *)eventPath
{
    return _eventPath;
}

// -------------------------------------------------------------------------------
// setEventPath:
//
// Sets the event path of this event to the supplied path.
// -------------------------------------------------------------------------------
- (void)setEventPath:(NSString *)eventPath
{
    if (_eventPath != eventPath) {
        _eventPath = eventPath;
    }
}

// -------------------------------------------------------------------------------
// eventFlag
//
// Returns the event flag of this event. This is one of the FSEventStreamEventFlags
// defined in FSEvents.h. See this header for possible constants and there meanings.
// -------------------------------------------------------------------------------
- (FSEventStreamEventFlags)eventFlag
{
    return _eventFlag;
}

// -------------------------------------------------------------------------------
// setEventFlag:
//
// Sets the event flag of this event to the supplied flag. Must be one of the 
// FSEventStreamEventFlags constants defined in FSEvents.h.
// -------------------------------------------------------------------------------
- (void)setEventFlag:(FSEventStreamEventFlags)eventFlag
{
    if (_eventFlag != eventFlag) {
        _eventFlag = eventFlag;
    }
}

@end