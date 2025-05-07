#!/bin/bash

# Usage: ./has-local-seamlesspay-ios.sh <pbxproj-path>
PBXPROJ_PATH="${1:-ios-sdk-example.xcodeproj/project.pbxproj}"
LOCAL_REF='../seamlesspay-ios'

# Check if the project file exists
if [ ! -f "$PBXPROJ_PATH" ]; then
    echo "Error: $PBXPROJ_PATH does not exist." >&2
    exit 2
fi

# Look for a block that defines a local seamlesspay-ios package reference
found=0
while IFS= read -r line; do
    if [[ "$line" == *"isa = XCLocalSwiftPackageReference;"* ]]; then
        read -r next_line
        if [[ "$next_line" == *"relativePath = \"$LOCAL_REF\";"* ]]; then
            found=1
            break
        fi
    fi
done < "$PBXPROJ_PATH"

if [ $found -eq 1 ]; then
    echo "The project.pbxproj file contains a reference to the local seamlesspay-ios package."
    exit 0
else
    echo "The project.pbxproj file does not contain a reference to the local seamlesspay-ios package."
    exit 1
fi