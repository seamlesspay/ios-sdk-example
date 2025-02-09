# SeamlessPay iOS Example Application

## Overview

The iOS Example Application demonstrates the basic usage of UI components. The application includes examples of initializing UI components with different configurations. It enables you to process tokenization, refunds, and charge requests.

## Configuration

Make sure to replace the placeholder authorization data with your own to successfully execute the requests.

```swift
enum DemoAuth {
  static let secretKey: String = "sk_XXXXXXXXXXXXXXXXXXXXXXXXXX"
  static let environment: SeamlessPay.Environment = .staging
  static let proxyAccountId: String? = "MRT_XXXXXXXXXXXXXXXXXXXXXXXXXX"
}

```

## Build and Run

Once you have completed the setup, select the "Example" scheme, and run the project.