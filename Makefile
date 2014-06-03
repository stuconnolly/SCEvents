# $Id$

CONFIG=Release

BUILD_CONFIG?=$(CONFIG)

RM=rm
CP=ditto --rsrc
EX=/tmp/ex.tmp

.PHONY: scevents test clean clean-all latest dist

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

dist:
	cd ../; \
	\
	find SCEvents | grep .DS_Store > "$(EX)"; \
	find SCEvents | grep .*\.svn.* >> "$(EX)"; \
	find SCEvents | grep .*\.pbxuser.* >> "$(EX)"; \
	find SCEvents | grep .*\.perspective.* >> "$(EX)"; \
	find SCEvents | grep .*\.xcuserdata.* >> "$(EX)"; \
	find SCEvents | grep .*\.xcworkspace.* >> "$(EX)"; \
	\
	tar -cvf - -X "$(EX)" SCEvents | bzip2 > "SCEvents-$(VERSION).tar.bz2"; rm "$(EX)"
