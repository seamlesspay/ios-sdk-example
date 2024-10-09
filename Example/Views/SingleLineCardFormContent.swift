// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

struct SingleLineCardFormContent: View {
  private let singleLineCardForm: SingleLineCardForm

  init(
    config: SeamlessPay.ClientConfiguration,
    fieldOptions: FieldOptions
  ) {
    singleLineCardForm = SingleLineCardForm(
      config: config,
      fieldOptions: fieldOptions
    )
  }

  var body: some View {
    CardFormContent(
      header: "SingleLine Card Form",
      cardFromRepresentable: AnyView(SingleLineCardFormUI(cardForm: singleLineCardForm)),
      tokenize: singleLineCardForm.tokenize,
      charge: singleLineCardForm.charge(_:completion:),
      refund: singleLineCardForm.refund(_:completion:)
    )
  }
}

#Preview {
  SingleLineCardFormContent(
    config: .init(
      environment: .sandbox,
      secretKey: .init()
    ),
    fieldOptions: .default
  )
}
