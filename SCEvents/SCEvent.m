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
// eventWithEventId:eventPath:eventFlag:
//
// Returns an initialized instance of SCEvent using the supplied event ID, path 
// and flag.
// -------------------------------------------------------------------------------
+ (SCEvent *)eventWithEventId:(NSUInteger)eventId eventDate:(NSDate *)date eventPath:(NSString *)eventPath eventFlag:(FSEventStreamEventFlags)eventFlag
{
    return [[[SCEvent alloc] initWithEventId:eventId eventDate:date eventPath:eventPath eventFlag:eventFlag] autorelease];
}

// -------------------------------------------------------------------------------
// initWithEventId:eventPath:eventFlag:
//
// Initializes an instance of SCEvent using the supplied event ID, path and flag.
// -------------------------------------------------------------------------------
- (id)initWithEventId:(NSUInteger)eventId eventDate:(NSDate *)date eventPath:(NSString *)eventPath eventFlag:(FSEventStreamEventFlags)eventFlag
{
    if ((self = [super init])) {
        [self setEventId:eventId];
        [self setEventDate:date];
        [self setEventPath:eventPath];
        [self setEventFlag:eventFlag];
    }
    
    return self;
}

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
// eventDate
//
// Returns the date of this event.
// -------------------------------------------------------------------------------
- (NSDate *)eventDate
{
    return _eventDate;
}

// -------------------------------------------------------------------------------
// setEventDate:
//
// Sets the event date of this event to the supplied date.
// -------------------------------------------------------------------------------
- (void)setEventDate:(NSDate *)date
{
    if (_eventDate != date) {
        [_eventDate release];
        _eventDate = [date retain];
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

// -------------------------------------------------------------------------------
// description
//
// Provides the string used when printing this object in NSLog, etc. Useful for
// debugging purposes.
// -------------------------------------------------------------------------------
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ { eventId = %d, eventPath = %@, eventFlag = %d } >", [self className], _eventId, _eventPath, _eventFlag];
}

// -------------------------------------------------------------------------------
// dealloc
// -------------------------------------------------------------------------------
- (void)dealloc
{
    [_eventDate release], _eventDate = nil;
    [super dealloc];
}

@end