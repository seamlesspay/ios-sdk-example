#!/bin/bash

PBXPROJ_PATH="ios-sdk-example.xcodeproj/project.pbxproj"
TARGET_DIR="../seamlesspay-ios"

if [[ "$(uname -m)" == arm64 ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

if "./scripts/has-local-seamlesspay-package.sh" "$PBXPROJ_PATH"; then
    if command -v swiftlint >/dev/null 2>&1; then
        if [ -d "$TARGET_DIR" ]; then
            cd "$TARGET_DIR"
            swiftlint
            echo "info [swiftlint]: Swiftlint successfully ran in $TARGET_DIR."
        else
            echo "warning [swiftlint]: Target directory $TARGET_DIR does not exist."
        fi
    else
        echo "warning [swiftlint]: \`swiftlint\` command not found - See https://github.com/realm/SwiftLint#installation for installation instructions."
    fi
else
    echo "info [swiftlint]: No local seamlesspay-ios reference found in $PBXPROJ_PATH, skipping swiftlint."
fi