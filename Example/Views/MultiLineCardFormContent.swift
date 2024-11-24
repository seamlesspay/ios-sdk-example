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
    fieldOptions: SeamlessPay.FieldOptions,
    styleOptions: SeamlessPay.StyleOptions
  ) {
    cardForm = MultiLineCardForm(
      config: config,
      fieldOptions: fieldOptions,
      styleOptions: styleOptions
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
    fieldOptions: .default,
    styleOptions: .default
  )
}
