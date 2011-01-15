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

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

/**
 *
 *
 */
@interface SCEvent : NSObject 
{
    NSUInteger _eventId;
    NSDate *_eventDate;
    NSString *_eventPath;
    FSEventStreamEventFlags _eventFlag;
}

@property (readwrite, assign, getter=eventId, setter=setEventId:) NSUInteger _eventId;
@property (readwrite, retain, getter=eventDate, setter=setEventDate:) NSDate *_eventDate;
@property (readwrite, retain, getter=eventPath, setter=setEventPath:) NSString *_eventPath;
@property (readwrite, assign, getter=eventFlag, setter=setEventFlag:) FSEventStreamEventFlags _eventFlag;

+ (SCEvent *)eventWithEventId:(NSUInteger)identifier 
					eventDate:(NSDate *)date 
					eventPath:(NSString *)path 
					eventFlag:(FSEventStreamEventFlags)flag;

- (id)initWithEventId:(NSUInteger)identifier 
			eventDate:(NSDate *)date 
			eventPath:(NSString *)path 
			eventFlag:(FSEventStreamEventFlags)flag;

@end