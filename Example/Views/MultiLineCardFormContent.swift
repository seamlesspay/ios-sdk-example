// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

struct MultiLineCardFormContent: View {
  private let cardForm: MultiLineCardForm

  init(
    config: SeamlessPay.ClientConfiguration,
    fieldOptions: FieldOptions
  ) {
    cardForm = MultiLineCardForm(
      config: config,
      fieldOptions: .init(cvv: .init(display: .required), postalCode: .init(display: .required))
    )
  }

  var body: some View {
    CardFormContent(
      header: "MultiLine Card Form",
      cardFromRepresentable: AnyView(MultiLineCardFormUI(cardForm: cardForm)),
      tokenize: cardForm.tokenize,
      charge: cardForm.charge(_:completion:),
      refund: cardForm.refund(_:completion:)
    )
  }
}

#Preview {
  MultiLineCardFormContent(
    config: .init(
      environment: .sandbox,
      secretKey: .init()
    ),
    fieldOptions: .default
  )
}
