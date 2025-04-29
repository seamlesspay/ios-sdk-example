// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import PassKit
import SwiftUI
import SeamlessPay

struct ApplePayContent: View {
  @State private var isRquestInProgress: Bool = false
  
  let applePayHandler: ApplePayHandler
  @Binding var transaction: Transaction
  let onPaymentResult: (PaymentResponseResult?) -> Void

  var body: some View {
    if applePayHandler.canPerformPayments {
      ZStack {
        paymentForm(with: applePayHandler)
        paymentProgressView
      }
      .overlay {
        if isRquestInProgress {
          Color.black.opacity(0.25)
            .ignoresSafeArea()
        }
      }
    } else {
      unavailablePaymentText
    }
  }

  private func paymentForm(with applePayHandler: ApplePayHandler) -> some View {
    Form {
      Section {
        HStack(spacing: 32) {
          Text("Amount")
            .foregroundColor(.primary)
          TextField(
            "$",
            text: Binding(
              get: { transaction.amountRaw },
              set: { transaction = .charge(amount: $0) }
            )
          )
          .keyboardType(.decimalPad)
        }
      }
    }
    .safeAreaInset(edge: .bottom) {
      ApplePayButtonUI {
        withAnimation {
          isRquestInProgress = true
        }

        applePayHandler.presentApplePayFor(
          ChargeRequest(amount: transaction.cents)
        ) { result in
          withAnimation {
            isRquestInProgress = false
            switch result {
            case let .success(response):
              onPaymentResult(.init(kind: .success, value: response.debugDescription))
            case let .failure(error):
              onPaymentResult(.init(kind: .failure, value: error.localizedDescription))
            case .canceled:
              onPaymentResult(nil)
            }
          }
        }
      }
      .frame(height: 54)
      .withApplePaySimulatorNotice()
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
  private var paymentProgressView: some View {
    if isRquestInProgress {
      ProgressView()
    }
  }
}
