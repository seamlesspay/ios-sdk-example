// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SeamlessPay
import SwiftUI

extension Transaction.Kind {
  fileprivate var name: String {
    switch self {
    case .tokenizeOnly: return "Tokenize-only"
    case .charge: return "Charge"
    case .refund: return "Refund"
    }
  }
}

struct TransactionOptionsView: View {
  @State private var sTransaction: Transaction = .init(kind: .tokenizeOnly, amountRaw: "")

  @Binding var contentType: ContentType?

  var body: some View {
    Form {
      Section("Payment Options") {
        ForEach(Transaction.Kind.allCases, id: \.self) { transactionType in
          Button {
            sTransaction = Transaction(
              kind: transactionType,
              amountRaw: sTransaction.amountRaw
            )
          } label: {
            HStack {
              Text(transactionType.name)
                .foregroundColor(.primary)
              Spacer()
              if sTransaction.kind == transactionType {
                Image(systemName: "checkmark")
                  .foregroundColor(.accentColor)
              }
            }
          }
        }
      }

      if sTransaction.kind != .tokenizeOnly {
        Section {
          HStack(spacing: 32) {
            Text("Amount")
              .foregroundColor(.primary)
            TextField(
              "$",
              text: Binding(
                get: { sTransaction.amountRaw },
                set: {
                  sTransaction = Transaction(
                    kind: sTransaction.kind,
                    amountRaw: $0
                  )
                }
              )
            )
            .keyboardType(.decimalPad)
          }
        }
      }
    }
    .withDoneNavigation(contentType: $contentType)
    .navigationTitle("Card Form")
    .navigationBarTitleDisplayMode(.inline)
    .safeAreaInset(edge: .bottom) {
      continueButton
    }
  }

  private var continueButton: some View {
    NavigationLink {
      cardFormView
    } label: {
      Text("Continue")
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    .buttonStyle(.borderedProminent)
    .padding()
    .foregroundColor(.white)
  }

  private var cardFormView: some View {
    CardFormContent(
      transaction: sTransaction,
      config: .init(
        environment: DemoAuth.environment,
        secretKey: DemoAuth.secretKey,
        proxyAccountId: DemoAuth.proxyAccountId
      ),
      fieldOptions: FieldOptions(
        cvv: FieldConfiguration(display: .required),
        postalCode: FieldConfiguration(display: .required)
      ),
      styleOptions: .default,
      contentType: $contentType
    )
  }
}

#Preview {
  TransactionOptionsView(contentType: .constant(.cardForm))
}
