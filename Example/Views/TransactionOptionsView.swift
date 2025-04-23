// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay


private extension Transaction.Kind {
  var name: String {
    switch self {
    case .tokenizeOnly: return "Tokenize-only"
    case .charge: return "Charge"
    case .refund: return "Refund"
    }
  }
}

struct TransactionOptionsView: View {
  @State private var sTransaction: Transaction = .init(kind: .tokenizeOnly, amount: "")
    
  var body: some View {
    Form {
      Section("Payment Options") {
        ForEach(Transaction.Kind.allCases, id: \.self) { transactionType in
          Button {
            sTransaction = Transaction(
              kind: transactionType,
              amount: sTransaction.amount
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
          TextField(
            "Amount $",
            text: Binding(
              get: { sTransaction.amount },
              set: { sTransaction = Transaction(
                kind: sTransaction.kind,
                amount: $0
              ) }
            )
          )
          .keyboardType(.decimalPad)
        }
      }
    }
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
    .disabled(sTransaction.kind != .tokenizeOnly && sTransaction.amount.isEmpty)
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
      styleOptions: .default
    )
  }
}

#Preview {
  TransactionOptionsView()
}
