// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

struct CardFormContent: View {
  @State var status: RequestStatus = .idle

  let header: String
  let cardFormOrigin: CardForm
  
  init(
    header: String,
    config: SeamlessPay.ClientConfiguration,
    fieldOptions: SeamlessPay.FieldOptions,
    styleOptions: SeamlessPay.StyleOptions
  ) {
    self.header = header
    cardFormOrigin = CardForm(
      config: config,
      fieldOptions: fieldOptions,
      styleOptions: styleOptions
    )
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        Text(header)
          .fontWeight(.bold)
        cardForm
          .frame(height: 350)

        HStack {
          actionButton(title: "Tokenize") {
            cardForm.tokenize {
              processResult($0)
            }
          }
          actionButton(title: "Pay") {
            cardForm.charge(ChargeRequest(amount: 125)) {
              processResult($0)
            }
          }
          actionButton(title: "Refund") {
            cardForm.refund(RefundRequest(amount: 125)) {
              processResult($0)
            }
          }
        }

        Text(status.header)
          .lineLimit(1)
          .fontWeight(.bold)
          .foregroundColor(status.color)
        if status.inProgress {
          ProgressView()
            .foregroundColor(status.color)
        } else {
          Text(status.payload)
            .multilineTextAlignment(.leading)
        }
      }
      .padding(.horizontal)
    }
  }
  
  var cardForm: CardFormUI {
    CardFormUI(
      cardForm: cardFormOrigin
    )
  }

  @ViewBuilder
  private func actionButton(title: String, action: @escaping () -> Void) -> some View {
    Button {
      withAnimation {
        status = .processing
        action()
      }
    } label: {
      Text(title)
    }
    .buttonStyle(.borderedProminent)
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
}
