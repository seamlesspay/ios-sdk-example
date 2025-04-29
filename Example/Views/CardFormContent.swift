// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

struct CardFormContent: View {
  @State private var result: PaymentResponseResult?
  @State private var isRquestInProgress: Bool = false
  private let cardFormOrigin: CardForm
  private let transaction: Transaction
  
  @Binding var contentType: ContentType?

  init(
    transaction: Transaction,
    config: SeamlessPay.ClientConfiguration,
    fieldOptions: SeamlessPay.FieldOptions,
    styleOptions: SeamlessPay.StyleOptions,
    contentType: Binding<ContentType?>
  ) {
    self.transaction = transaction
    cardFormOrigin = CardForm(
      config: config,
      fieldOptions: fieldOptions,
      styleOptions: styleOptions
    )
    _contentType = contentType
  }

  var body: some View {
    ZStack {
      ScrollView {
        cardForm
          .frame(height: 350)
          .disabled(isRquestInProgress)
          .padding(.horizontal)
        Spacer(minLength: 100)
        hintText
          .padding(.horizontal)
      }
      .background(Color(UIColor.systemGroupedBackground))

      if isRquestInProgress {
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
        .disabled(isRquestInProgress)
    }
    .overlay {
      if isRquestInProgress {
        Color.black.opacity(0.25)
          .ignoresSafeArea()
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Done") {
          contentType = .none
        }
      }
    }
    .navigationTitle("Card Form")
    .navigationBarTitleDisplayMode(.inline)
    .navigationDestination(item: $result) { value in
      PaymentResponseView(
        result: value,
        contentType: $contentType
      )
    }
  }

  private var cardForm: CardFormUI {
    CardFormUI(
      cardForm: cardFormOrigin
    )
  }

  private var continueButton: some View {
    Button {
      handleContinueButtonTap()
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
}

private extension CardFormContent {
  func handleContinueButtonTap() {
    func processResult(
      _ result: Result<some CustomDebugStringConvertible, APIError>?
    ) {
      isRquestInProgress = false

      switch result {
      case let .success(payload):
        self.result = .init(kind: .success, value: payload.debugDescription)
      case let .failure(error):
        self.result = .init(kind: .failure, value: error.debugDescription)
      default:
        self.result = .none
      }
    }

    isRquestInProgress = true

    switch transaction.kind {
    case .tokenizeOnly:
      cardForm.tokenize(completion: processResult)
    case .charge:
      cardForm.charge(
        ChargeRequest(amount: transaction.cents),
        completion: processResult
      )
    case .refund:
      cardForm.refund(
        RefundRequest(amount: transaction.cents),
        completion: processResult
      )
    }
  }
}

#Preview {
  CardFormContent(
    transaction: .init(kind: .charge, amountRaw: "2"),
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
    contentType: .constant(.cardForm)
  )
}
