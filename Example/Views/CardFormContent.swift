// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

struct CardFormContent: View {
  @State var displayResult: DisplayResult = .init(header: "RESULT", payload: "")
  @State var inProgress: Bool = false

  let header: String
  let cardFromRepresentable: AnyView
  let tokenize: (((Result<TokenizeResponse, SeamlessPayError>) -> Void)?) -> Void
  let charge: (
    _ request: ChargeRequest,
    ((Result<PaymentResponse, SeamlessPayError>) -> Void)?
  ) -> Void
  let refund: (
    _ request: RefundRequest,
    ((Result<PaymentResponse, SeamlessPayError>) -> Void)?
  ) -> Void

  var body: some View {
    List {
      Group {
        Section(header: Text(header)) {
          cardFromRepresentable
            .frame(height: 300)
            .frame(maxWidth: .infinity)
        }

        Section(header: Text("Capabilities")) {
          HStack {
            Button {
              startProgress()
              tokenize {
                processResult($0)
              }
            } label: {
              Text("Tokenize")
            }
            .buttonStyle(.borderedProminent)

            Button {
              startProgress()
              Task {
                charge(ChargeRequest(amount: 100)) { result in
                  processResult(result)
                }
              }
            } label: {
              Text("Pay")
            }
            .buttonStyle(.borderedProminent)

            Button {
              startProgress()
              refund(RefundRequest(amount: 100)) {
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
