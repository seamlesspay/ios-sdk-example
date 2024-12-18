// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import PassKit
import SeamlessPay

struct ApplePayButtonUI: UIViewRepresentable {
  let action: () -> Void

  init(
    action: @escaping () -> Void
  ) {
    self.action = action
  }

  func makeUIView(context: Context) -> PKPaymentButton {
    context.coordinator.button
  }

  func updateUIView(_ uiView: PKPaymentButton, context: Context) {
    context.coordinator.action = action
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(action: action)
  }

  class Coordinator: NSObject {
    var action: () -> Void
    var button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .automatic)

    init(
      action: @escaping () -> Void
    ) {
      self.action = action
      super.init()
      button.addTarget(
        self,
        action: #selector(buttonTapped(_:)),
        for: .touchUpInside
      )
    }

    @objc func buttonTapped(_ sender: PKPaymentButton) {
      action()
    }
  }
}
