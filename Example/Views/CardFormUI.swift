// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

struct CardFormUI: UIViewRepresentable {
  private let cardForm: CardForm

  init(cardForm: CardForm) {
    self.cardForm = cardForm
  }

  func makeUIView(context: Context) -> CardForm {
    return cardForm
  }

  func updateUIView(_ uiView: CardForm, context: Context) {}

  func makeCoordinator() -> CardFormUICoordinator {
    CardFormUICoordinator(cardFormUI: self)
  }
}

class CardFormUICoordinator: NSObject, CardFormDelegate {
  let cardFormUI: CardFormUI
  init(cardFormUI: CardFormUI) {
    self.cardFormUI = cardFormUI
  }

  // MARK: CardFormDelegate
  func cardFormDidChange(_ view: CardForm) {}
}
