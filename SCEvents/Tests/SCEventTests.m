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

#import "SCEventTests.h"
#import "SCEvent.h"
#import "SCConstants.h"

// Constants
static NSUInteger SCEventTestId = 17872;
static NSString *SCEventTestDir = @"Documents";
static SCEventFlags SCEventTestFlags = SCEventStreamEventFlagNone;

@implementation SCEventTests

@synthesize _eventId;
@synthesize _eventDate;
@synthesize _eventPath;
@synthesize _eventFlags;

#pragma mark -
#pragma mark Setup and teardown

- (void)setUp
{
	NSDate *date = [NSDate date];
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:SCEventTestDir];
	
	_event = [[SCEvent alloc] initWithEventId:SCEventTestId 
									eventDate:date
									eventPath:path
								   eventFlags:SCEventTestFlags];
	
	_eventId    = SCEventTestId;
	_eventDate  = date;
	_eventPath  = path;
	_eventFlags = SCEventStreamEventFlagNone;
}

- (void)tearDown
{
	[_event release], _event = nil;
}

#pragma mark -
#pragma mark Tests

- (void)testEventId
{
	STAssertEquals(_eventId, [_event eventId], nil);
}

- (void)testEventDate
{
	STAssertEquals(_eventDate, [_event eventDate], nil);
}

- (void)testEventPath
{
	STAssertEquals(_eventPath, [_event eventPath], nil);
}

- (void)testEventFlags
{
	STAssertEquals(SCEventStreamEventFlagNone, [_event eventFlags], nil);
}

@end
