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
    let coordinator = CardFormUICoordinator(cardFormUI: self)
    cardForm.delegate = coordinator
    return coordinator
  }
  
  func tokenize(
    completion: ((Result<TokenizeResponse, APIError>?) -> Void)?
  ) {
    cardForm.tokenize(completion: completion)
  }
  
  func charge(
    _ request: ChargeRequest,
    completion: ((Result<PaymentResponse, APIError>?) -> Void)?
  ) {
    cardForm.charge(request, completion: completion)
  }
  
  func refund(
    _ request: RefundRequest,
    completion: ((Result<PaymentResponse, APIError>?) -> Void)?
  ) {
    cardForm.refund(request, completion: completion)
  }
}

class CardFormUICoordinator: NSObject, CardFormDelegate {
  let cardFormUI: CardFormUI
  init(cardFormUI: CardFormUI) {
    self.cardFormUI = cardFormUI
  }

  // MARK: CardFormDelegate
  func cardFormDidChange(_ form: CardFormProtocol) {
    print("is CardForm valid = ", form.isValid)
  }

  func cardFormWillEndEditing(forReturn form: CardFormProtocol) {
    print("is CardForm valid = ", form.isValid)
  }
}
