#!/bin/bash

# Path to the project.pbxproj file
PBXPROJ_PATH="ios-sdk-example.xcodeproj/project.pbxproj"

# Check if the file exists
if [ ! -f "$PBXPROJ_PATH" ]; then
    echo "Error: $PBXPROJ_PATH does not exist."
    exit 1
fi

# Search for local swift package references in the file
if grep -q "XCLocalSwiftPackageReference" "$PBXPROJ_PATH"; then
    echo "Error: Commit blocked. The project.pbxproj file contains a reference to the local swift package."
    echo "Please ensure that you change the local package reference to the published version before making any commits."
    exit 1
fi

# If we reach here, the check passed
echo "Pre-commit check passed."
exit 0