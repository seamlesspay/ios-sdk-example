// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import PassKit
import SeamlessPay
import SwiftUI

struct ApplePayContent: View {
  @State private var result: PaymentResponseResult?
  @State private var isRquestInProgress: Bool = false
  @State var applePayHandler: ApplePayHandler?
  private let config: ClientConfiguration

  @State private var transaction: Transaction = .charge(amount: "")

  init(config: ClientConfiguration) {
    self.config = config
  }

  var body: some View {
    VStack(spacing: 16) {
      if let applePayHandler {
        if applePayHandler.canPerformPayments {
          ZStack {
            form
            paymentProgressView
          }
        } else {
          unavailablePaymentText
        }
      } else {
        ProgressView()
      }
    }
    .overlay {
      if isRquestInProgress {
        Color.black.opacity(0.25)
          .ignoresSafeArea()
      }
    }
    .navigationTitle("Card Form")
    .navigationBarTitleDisplayMode(.inline)
    .navigationDestination(item: $result) { value in
      PaymentResponseView(
        result: value
      )
    }
    .task {
      self.applePayHandler = await ApplePayHandler(config: config)
    }
  }

  private var form: some View {
    Form {
      Section {
        TextField(
          "Amount $",
          text: Binding(
            get: { transaction.amount },
            set: { transaction = .charge(amount: $0) }
          )
        )
        .keyboardType(.decimalPad)
      }
    }
    .safeAreaInset(edge: .bottom) {
      ApplePayButtonUI {
        withAnimation {
          isRquestInProgress = true
        }

        applePayHandler?.presentApplePayFor(
          ChargeRequest(amount: transaction.cents)
        ) { result in
          withAnimation {
            isRquestInProgress = false
            switch result {
            case let .success(response):
              self.result = .init(kind: .success, value: response.debugDescription)
            case let .failure(error):
              self.result = .init(kind: .failure, value: error.localizedDescription)
            case .canceled:
              self.result = .none
            }
          }
        }
      }
      .frame(width: 200)
      .frame(height: 50)
      .withApplePaySimulatorNotice()
      .disabled(transaction.amount.isEmpty)
      .padding()
    }
  }

  private var unavailablePaymentText: some View {
    Text(
      """
      Payment processing is not available. 
      The `ApplePayHandler.canPerformPayments` is `false`. Please check SeamlessPay SDK configuration. And your device's capabilities to satisfy the `PKPaymentAuthorizationController.canMakePayments()`
      """
    )
  }

  @ViewBuilder
  var paymentProgressView: some View {
    if isRquestInProgress {
      ProgressView()
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
