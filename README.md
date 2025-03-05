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

You can also modify the field configuration yourself and initialize components with this data.

```swift
  let config = SeamlessPay.ClientConfiguration(
    environment: .sandbox,
    secretKey: "sk_XXXXXXXXXXXXXXXXXXXXXXXXXX",
    proxyAccountId: "MRT_XXXXXXXXXXXXXXXXXXXXXXXXXX"
  )

  cardForm = MultiLineCardForm(
    config: config,
    fieldOptions: FieldOptions.default,
    styleOptions: StyleOptions.default
  )

  applePayHandler = await ApplePayHandler(config: config)
```

## Build and Run

Once you have completed the setup, select the "Example" scheme, and run the project.