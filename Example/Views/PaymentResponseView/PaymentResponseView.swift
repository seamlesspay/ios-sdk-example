// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

struct PaymentResponseResult: Hashable {
  enum Kind: Hashable {
    case success
    case failure
  }

  let kind: Kind
  let value: String
}

struct PaymentResponseView: View {
  let result: PaymentResponseResult

  @Binding var contentType: ContentType?

  var body: some View {
    VStack(spacing: 32) {
      StatusHeader(kind: result.kind)
      VStack(alignment: .leading, spacing: 8) {
        Text("RESPONSE CODE")
          .font(.caption)
          .foregroundColor(.secondary)

        Text(result.value)
          .font(.system(.body, design: .monospaced))
          .padding()
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(spTableBackgroundColor)
          .cornerRadius(8)
      }

      Spacer()

      CopyButton(title: "Copy Response", textToCopy: result.value)
    }
    .padding()
    .withBackNavigation()
    .withDoneNavigation(contentType: $contentType)
    .navigationTitle("Card Form")
    .navigationBarTitleDisplayMode(.inline)
    .background(Color(UIColor.systemGroupedBackground))
  }
}

#Preview("Success Response") {
  NavigationView {
    PaymentResponseView(
      result: PaymentResponseResult(
        kind: .success,
        value: """
          Payment Response:
            - ID: txn_123456789
            - Payment Token: pmt_token_abc123
            - Details:
                - Amount: 50.00
                - Auth Code: A12345
                - Batch ID: batch_987
                - Last Four: 4242
                - Card Brand: VISA
                - Status: APPROVED
                - Status Code: 00
                - Status Description: Transaction Approved
                - Transaction Date: 2024-03-21T15:30:00Z
                - Postal Code AVS Result: MATCH
                - Street Address AVS Result: MATCH
                - CVV AVS Result: MATCH
                - Account Type: CREDIT
                - Currency: USD
                - Expiration Date: 12/25
                - Tip: 10.00
          """
      ),
      contentType: .constant(.cardForm)
    )
  }
}

#Preview("Failure Response") {
  NavigationView {
    PaymentResponseView(
      result: PaymentResponseResult(
        kind: .failure,
        value: """
          API Error:
            - Kind: Declined
            - Status Code: 05
            - Status Description: Do not honor
            - Errors:
                - Message: Card was declined by issuer, Field Name: card
                - Message: Insufficient funds, Field Name: payment
          """
      ),
      contentType: .constant(.cardForm)
    )
  }
}
