// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

struct MultiLineCardFormUI: UIViewRepresentable {
  private let cardForm: MultiLineCardForm

  init(cardForm: MultiLineCardForm) {
    self.cardForm = cardForm
  }

  func makeUIView(context: Context) -> MultiLineCardForm {
    return cardForm
  }

  func updateUIView(_ uiView: MultiLineCardForm, context: Context) {}

  func makeCoordinator() -> MultiLineCardFormUICoordinator {
    let coordinator = MultiLineCardFormUICoordinator(cardFormUI: self)
    cardForm.delegate = coordinator
    return coordinator
  }
}

class MultiLineCardFormUICoordinator: NSObject, CardFormDelegate {
  let cardFormUI: MultiLineCardFormUI
  init(cardFormUI: MultiLineCardFormUI) {
    self.cardFormUI = cardFormUI
  }

  // MARK: CardFormDelegate
  func cardFormDidChange(_ form: CardForm) {
      print("is MultiLineCardForm valid = ", form.isValid)
  }

  func cardFormWillEndEditing(forReturn form: CardForm) {
    print("is MultiLineCardForm valid = ", form.isValid)
  }
}

struct SingleLineCardFormUI: UIViewRepresentable {
  private let cardForm: SingleLineCardForm

  init(cardForm: SingleLineCardForm) {
    self.cardForm = cardForm
  }

  func makeUIView(context: Context) -> SingleLineCardForm {
    return cardForm
  }

  func updateUIView(_ uiView: SingleLineCardForm, context: Context) {}

  func makeCoordinator() -> SingleLineCardFormUICoordinator {
    let coordinator = SingleLineCardFormUICoordinator(cardFormUI: self)
    cardForm.delegate = coordinator
    return coordinator
  }
}

class SingleLineCardFormUICoordinator: NSObject, CardFormDelegate {
  let cardFormUI: SingleLineCardFormUI
  init(cardFormUI: SingleLineCardFormUI) {
    self.cardFormUI = cardFormUI
  }

  // MARK: CardFormDelegate
  func cardFormDidChange(_ form: CardForm) {
    print("is SingleLineCardForm valid = ", form.isValid)
  }
}
