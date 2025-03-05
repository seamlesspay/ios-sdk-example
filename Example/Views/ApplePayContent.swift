// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import PassKit
import SeamlessPay

struct ApplePayContent: View {
  @State var status: RequestStatus = .idle

  @State var applePayHandler: ApplePayHandler?

  private let config: ClientConfiguration

  init(config: ClientConfiguration) {
    self.config = config
  }

  var body: some View {
    VStack(spacing: 16) {
      if let applePayHandler {
        if applePayHandler.canPerformPayments {
          ApplePayButtonUI {
            withAnimation {
              status = .processing
            }

            applePayHandler.presentApplePayFor(ChargeRequest(amount: 125)) { result in
              withAnimation {
                switch result {
                case let .success(response):
                  status = .success(response.debugDescription)
                case let .failure(error):
                  status = .failure(error.debugDescription)
                case .canceled:
                  status = .failure("Payment was canceled by the user.")
                }
              }
            }
          }
          .frame(width: 200)
          .frame(height: 50)
          .withApplePaySimulatorNotice()
        } else {
          Text(
            "Payment processing is not available. The `ApplePayHandler.canPerformPayments` is `false`. Please check SeamlessPay SDK configuration. And your device's capabilities to satisfy the `PKPaymentAuthorizationController.canMakePayments()`"
          )
        }
      } else {
        ProgressView()
      }

      Group {
        HStack {
          if let iconName = status.iconName {
            Image(systemName: iconName)
          }
          Text(status.header)
            .lineLimit(1)
            .fontWeight(.bold)
        }
        if status.inProgress {
          ProgressView()
        } else {
          Text(status.payload)
            .multilineTextAlignment(.leading)
            .lineLimit(.max)
        }
      }
      .foregroundColor(status.color)
    }
    .padding()
    .task {
      self.applePayHandler = await ApplePayHandler(config: config)
    }
  }
}

#Preview {
  ApplePayContent(
    config: .init(
      environment: .sandbox,
      secretKey: .init()
    )
  )
}
