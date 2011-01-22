# $Id$

CONFIG=Release

BUILD_CONFIG?=$(CONFIG)

RM=rm
CP=ditto --rsrc

.PHONY: scevents test clean clean-all latest

scevents:
	xcodebuild -project SCEvents.xcodeproj -configuration "$(BUILD_CONFIG)" CFLAGS="$(FLAGS)" build

test:
	xcodebuild -project SCEvents.xcodeproj -configuration "$(BUILD_CONFIG)" CFLAGS="$(FLAGS)" -target Tests build

clean:
	xcodebuild -project SCEvents.xcodeproj -configuration "$(BUILD_CONFIG)" -nodependencies clean

clean-all:
	xcodebuild -project SCEvents.xcodeproj -configuration "$(BUILD_CONFIG)" clean

latest:
	svn update
	make scevents
