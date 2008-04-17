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

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

@interface SCEvent : NSObject 
{
    NSUInteger _eventId;
    NSString *_eventPath;
    
    FSEventStreamEventFlags _eventFlag;
}

+ (SCEvent *)eventWithEventId:(NSUInteger)eventId eventPath:(NSString *)eventPath eventFlag:(FSEventStreamEventFlags)eventFlag;

- (id)initWithEventId:(NSUInteger)eventId eventPath:(NSString *)eventPath eventFlag:(FSEventStreamEventFlags)eventFlag;

- (NSUInteger)eventId;
- (void)setEventId:(NSUInteger)eventId;

- (NSString *)eventPath;
- (void)setEventPath:(NSString *)eventPath;

- (FSEventStreamEventFlags)eventFlag;
- (void)setEventFlag:(FSEventStreamEventFlags)eventFlag;

@end