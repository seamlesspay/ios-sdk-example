// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

private extension Transaction {
  var cents: Int {
    // Convert string to decimal number
    guard let decimal = Decimal(string: amount) else { return 0 }
        
    // Multiply by 100 to convert dollars to cents and round to nearest cent
    let cents = decimal * 100
    return NSDecimalNumber(decimal: cents).intValue
  }
  
  var formattedAmount: String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.currencyCode = "USD"
    let amount = NSNumber(value: Double(cents) / 100.0)
    return numberFormatter.string(from: amount) ?? "$0.00"
  }
}

struct CardFormContent: View {
  @State var status: RequestStatus = .idle
  let cardFormOrigin: CardForm
  let transaction: Transaction
  
  init(
    transaction: Transaction,
    config: SeamlessPay.ClientConfiguration,
    fieldOptions: SeamlessPay.FieldOptions,
    styleOptions: SeamlessPay.StyleOptions
  ) {
    self.transaction = transaction
    cardFormOrigin = CardForm(
      config: config,
      fieldOptions: fieldOptions,
      styleOptions: styleOptions
    )
  }

  var body: some View {
    ZStack {
      ScrollView {
        cardForm
          .frame(height: 350)
          .disabled(status.inProgress)
          .padding(.horizontal)
        Spacer(minLength: 100)
          hintText
            .padding(.horizontal)
      }
      .background(Color(UIColor.systemGroupedBackground))
      
      if status.inProgress {
        HStack {
          ProgressView()
            .foregroundColor(.primary)
          Text("Processing")
            .foregroundColor(.primary)
        }
        .padding()
      }
    }
    .safeAreaInset(edge: .bottom) {
      continueButton
        .disabled(status.inProgress)
    }
    .overlay {
      if status.inProgress {
        Color.black.opacity(0.25)
          .ignoresSafeArea()
      }
    }
    .navigationTitle("Card Form")
  }
  
  private var cardForm: CardFormUI {
    CardFormUI(
      cardForm: cardFormOrigin
    )
  }

  private var continueButton: some View {
    Button {
      status = .processing
      
      switch transaction.kind {
      case .tokenizeOnly:
        
        cardForm.tokenize {
          processResult($0)
        }
      case .charge:
        cardForm.charge(
          ChargeRequest(amount: transaction.cents)
        ) {
          processResult($0)
        }
      case .refund:
        cardForm.refund(
          RefundRequest(amount: transaction.cents)
        ) {
          processResult($0)
        }
      }
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

  private var hintText: some View {
    var hint = "You are about to "
    
    switch transaction.kind {
    case .tokenizeOnly:
      hint += "tokenize your card"
    case .charge:
      hint += "charge \(transaction.formattedAmount)"
    case .refund:
      hint += "refund \(transaction.formattedAmount)"
    }
    
    return Text(hint)
  }

  private func processResult(
    _ result: Result<some CustomDebugStringConvertible, APIError>?
  ) {
    withAnimation {
      switch result {
      case let .success(payload):
        status = .success(payload.debugDescription)
      case let .failure(error):
        status = .failure(error.debugDescription)
      default:
        status = .idle
      }
    }
  }
}

#Preview {
  CardFormContent(
    transaction: .init(kind: .charge, amount: "2"),
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
