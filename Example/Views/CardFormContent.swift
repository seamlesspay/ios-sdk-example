// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

enum CardFormContentType: String, Identifiable {
  var id: String {
    rawValue
  }

  case single
  case multi
}

struct CardFormContent: View {
  struct DisplayResult {
    let header: String
    let payload: String
  }

  private let cardForm: CardForm
  @State var displayResult: DisplayResult = .init(header: "RESULT", payload: "")
  @State var inProgress: Bool = false

  init(config: SeamlessPay.ClientConfiguration, type: CardFormContentType) {
    let fieldOptions = FieldOptions.default

    switch type {
    case .single:
      cardForm = SingleLineCardForm(
        config: config,
        fieldOptions: fieldOptions
      )
    case .multi:
      cardForm = MultiLineCardForm(
        config: config,
        fieldOptions: fieldOptions
      )
    }
  }

  var body: some View {
    List {
      Group {
        Section(header: Text("Card Form")) {
          CardFormUI(cardForm: cardForm)
            .frame(height: 300)
            .frame(maxWidth: .infinity)
        }

        Section(header: Text("Capabilities")) {
          HStack {
            Button {
              startProgress()
              cardForm.tokenize {
                processResult($0)
              }
            } label: {
              Text("Tokenize")
            }
            .buttonStyle(.borderedProminent)


            Button {
              startProgress()
              Task {
                let result = await cardForm.charge(ChargeRequest(amount: 100))
                processResult(result)
              }
            } label: {
              Text("Pay")
            }
            .buttonStyle(.borderedProminent)

            Button {
              startProgress()
              cardForm.refund(RefundRequest(amount: 100)) {
                processResult($0)
              }
            } label: {
              Text("Refund")
            }
            .buttonStyle(.borderedProminent)
          }
          .frame(maxWidth: .infinity, alignment: .center)
        }

        Section(
          header: Text(displayResult.header)
        ) {
          VStack {
            if inProgress {
              ProgressView()
                .frame(maxWidth: .infinity, alignment: .center)
            }
            Text(displayResult.payload)
              .lineLimit(.none)
              .listRowSeparator(.hidden)
          }
        }
      }
      .listRowSeparator(.hidden)
      .listRowBackground(Color.clear)
    }
  }

  private func processResult(
    _ result: Result<some CustomDebugStringConvertible, SeamlessPayError>
  ) {
    inProgress = false
    switch result {
    case let .success(payload):
      displayResult = .init(header: "SUCCESS", payload: payload.debugDescription)
    case let .failure(error):
      displayResult = .init(header: "FAILURE", payload: error.localizedDescription)
    }
  }

  private func startProgress() {
    inProgress = true
    displayResult = .init(header: "RESULT", payload: "")
  }
}

#Preview {
  CardFormContent(
    config: .init(
      environment: .sandbox,
      secretKey: .init()
    ),
    type: .multi
  )
}
