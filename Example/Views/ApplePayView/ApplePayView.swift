// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import PassKit
import SeamlessPay
import SwiftUI

struct ApplePayView: View {
  @State private var result: PaymentResponseResult?
  @State private var transaction: Transaction = .charge(amount: "")
  private let config: ClientConfiguration

  @State var applePayHandler: ApplePayHandler?
  @Binding var contentType: ContentType?

  init(config: ClientConfiguration, contentType: Binding<ContentType?>) {
    self.config = config
    _contentType = contentType
  }

  var body: some View {
    VStack(spacing: 16) {
      if let applePayHandler {
        ApplePayContent(
          applePayHandler: applePayHandler,
          transaction: $transaction,
          onPaymentResult: { result in
            self.result = result
          }
        )
      } else {
        ProgressView()
      }
    }
    .withBackNavigation()
    .withDoneNavigation(contentType: $contentType)
    .navigationTitle("Apple Pay Button")
    .navigationBarTitleDisplayMode(.inline)
    .navigationDestination(item: $result) { value in
      PaymentResponseView(
        result: value,
        contentType: $contentType
      )
    }
    .task {
      self.applePayHandler = await ApplePayHandler(config: config)
    }
  }
}

#Preview {
  ApplePayView(
    config: .init(
      environment: .sandbox,
      secretKey: .init()
    ),
    contentType: .constant(.applePay)
  )
}
