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

#import "SCEventsTests.h"
#import "SCEvents.h"

static NSString *SCEventsDirectoryToIgnore = @"SCEventsTestsIgnore";

@interface SCEventsTests ()

- (BOOL)_createDirectoryAtPath:(NSString *)path;
- (BOOL)_deleteDirectoryAtPath:(NSString *)path;

@end

@implementation SCEventsTests

#pragma mark -
#pragma mark Setup and teardown

- (void)setUp
{
    _watcher = [[SCEvents alloc] init];
    
    [_watcher setDelegate:self];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSAllDomainsMask, YES);
    
	_pathToWatch  = ([paths count]) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
	_pathToIgnore = [_pathToWatch stringByAppendingPathComponent:SCEventsDirectoryToIgnore];
	    
	// Create the path to ignore
	if (![self _createDirectoryAtPath:_pathToIgnore]) {
		NSLog(@"Unable to create directory to ignore at path: %@. Some tests will fail.", _pathToIgnore);
	}
	
	// Set the paths to be excluded
	[_watcher setExcludedPaths:[NSMutableArray arrayWithObject:_pathToIgnore]];
	
	// Start receiving events
	[_watcher startWatchingPaths:[NSMutableArray arrayWithObject:_pathToWatch]];
}

- (void)tearDown
{
	if (![self _deleteDirectoryAtPath:_pathToIgnore]) {
		NSLog(@"You may need to remove this directory manually.");
	}
	
	[_watcher stopWatchingPaths];
	
	[_watcher release], _watcher = nil;
}

#pragma mark -
#pragma mark Tests

- (void)testStreamDescription
{
	STAssertTrue([[_watcher streamDescription] length], nil);
}

#pragma mark -
#pragma mark SCEventListenerProtocol methods

- (void)pathWatcher:(SCEvents *)pathWatcher eventOccurred:(SCEvent *)event
{
    
}

#pragma mark -
#pragma mark Private API

- (BOOL)_createDirectoryAtPath:(NSString *)path
{
	NSError *error = nil;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	BOOL success = [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
	
	if ((!success) || error) {
		NSLog(@"Unable to create directory at path '%@'. Error was: %@", path, [error localizedDescription]);
	}
	
	return success;
}

- (BOOL)_deleteDirectoryAtPath:(NSString *)path
{
	NSError *error = nil;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	BOOL success = [fileManager removeItemAtPath:path error:&error];
	
	if ((!success) || error) {
		NSLog(@"Unable to delete directory at path '%@'. Error was: %@", path, [error localizedDescription]);
	}
	
	return success;
}

@end
