// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SeamlessPay
import SwiftUI

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

    var body: some View {
        VStack(spacing: 16) {
            // Status Icon and Label
            statusHeader

            // Response Code Section
            VStack(alignment: .leading, spacing: 8) {
                Text("RESPONSE CODE")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(result.value)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(8)
            }

            Spacer()

            // Copy Response Button
            Button {
                UIPasteboard.general.string = result.value
            } label: {
                HStack {
                    Image(systemName: "doc.on.doc")
                    Text("Copy Response")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .buttonStyle(.borderless)
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Card Form")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground))
    }

    private var statusHeader: some View {
        HStack {
            switch result.kind {
            case .success:
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                Text("Success")
                    .foregroundColor(.white)
            case .failure:
                Image(systemName: "xmark.circle")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                Text("Error")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                switch result.kind {
                case .success:
                    Color.green
                case .failure:
                    Color.red
                }
            }
        )
        .cornerRadius(8)
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
            )
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
            )
        )
    }
}
