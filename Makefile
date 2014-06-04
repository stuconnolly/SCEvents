# $Id$

CONFIG=Release

BUILD_CONFIG?=$(CONFIG)

RM=rm
CP=ditto --rsrc
EX=/tmp/ex.tmp

.PHONY: scevents test analyze clean dist

scevents:
	xcodebuild -project SCEvents.xcodeproj -configuration "$(BUILD_CONFIG)" CFLAGS="$(FLAGS)" build

test:
	xcodebuild -project SCEvents.xcodeproj -scheme SCEvents -configuration "$(BUILD_CONFIG)" CFLAGS="$(FLAGS)" -target test

clean:
	xcodebuild -project SCEvents.xcodeproj -configuration "$(BUILD_CONFIG)" clean

dist:
	find . | grep .DS_Store > "$(EX)"; \
	find . | grep .*\.git.* >> "$(EX)"; \
	find . | grep .*\.pbxuser.* >> "$(EX)"; \
	find . | grep .*\.perspective.* >> "$(EX)"; \
	find . | grep .*\.xcuserdata.* >> "$(EX)"; \
	find . | grep .*\.xcworkspace.* >> "$(EX)"; \
	\
	tar -cvf - -X "$(EX)" . | bzip2 > "SCEvents-$(VERSION).tar.bz2"; rm "$(EX)"
