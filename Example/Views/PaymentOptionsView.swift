// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

enum CardFormTransactionType: CaseIterable {
  case tokenizeOnly
  case charge
  case refund
}

private extension CardFormTransactionType {
  var name: String {
    switch self {
    case .tokenizeOnly: return "Tokenize-only"
    case .charge: return "Charge"
    case .refund: return "Refund"
    }
  }
}

struct CardFormTransactionOptionsView: View {
  @State private var selectedTransaction: CardFormTransactionType = .tokenizeOnly
  @State private var amount: String = ""
    
  var body: some View {
    Form {
      Section("Payment Options") {
        ForEach(CardFormTransactionType.allCases, id: \.self) { transactionType in
          Button {
            selectedTransaction = transactionType
          } label: {
            HStack {
              Text(transactionType.name)
                .foregroundColor(.primary)
              Spacer()
              if selectedTransaction == transactionType {
                Image(systemName: "checkmark")
                  .foregroundColor(.accentColor)
              }
            }
          }
        }
      }
                
      if selectedTransaction != .tokenizeOnly {
        Section {
          TextField("Amount $", text: $amount)
            .keyboardType(.decimalPad)
        }
      }
    }
    .safeAreaInset(edge: .bottom) {
      NavigationLink {
        CardFormContent(
          header: "Card Form",
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
      } label: {
        Text("Continue")
          .fontWeight(.semibold)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 8)
      }
      .buttonStyle(.borderedProminent)
      .padding(16)
      .foregroundColor(.white)
    }
  }
}

#Preview {
  CardFormTransactionOptionsView()
}
