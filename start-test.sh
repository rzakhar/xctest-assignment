#!/bin/sh

#  start-test.sh
#  xctest-assignment
#
#  Created by rzakhar on 11.08.2019.
#  

#  Override the current PATH variable
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

#  Set variables
SIMNAME=$1
SIMOS=$2
LANGUAGE="en_US"
SIMDEVICETYPE="com.apple.CoreSimulator.SimDeviceType."
SIMDEVICEVERSION="com.apple.CoreSimulator.SimRuntime."

#  Prepare simulator
killall "Simulator"
xcrun simctl list | grep -w "Shutdown"  | grep -o "([-A-Z0-9]*)" | sed 's/[\(\)]//g' | xargs -I uid xcrun simctl delete uid
SIM=$(xcrun simctl create "$SIMNAME" "$SIMDEVICETYPE$SIMNAME" "$SIMDEVICEVERSION$SIMOS")
PREFERENCES_FILE="$HOME/Library/Developer/CoreSimulator/Devices/$SIM/data/Library/Preferences/.GlobalPreferences.plist"
plutil -replace AppleLanguages -json "[ \"$LANGUAGE\" ]" $PREFERENCES_FILE

#  Run tests
xcodebuild \
-project xctest-assignment.xcodeproj \
-scheme TestTarget \
-destination id=$SIM \
-destination-timeout 120 \
test
