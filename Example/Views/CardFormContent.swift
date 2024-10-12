// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

struct CardFormContent: View {
  @State var displayResult: DisplayResult = .init(header: "Result:", payload: "")
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
    VStack(spacing: 44) {
      VStack {
        Text(header)
          .fontWeight(.bold)
        cardFromRepresentable
          .padding(.horizontal)
      }
      VStack {
        Text("Capabilities")
          .fontWeight(.bold)
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

      VStack {
        Text(displayResult.header)
          .fontWeight(.bold)
        if inProgress {
          ProgressView()
            .frame(maxWidth: .infinity, alignment: .center)
        }
        Text(displayResult.payload)
          .lineLimit(.none)
          .multilineTextAlignment(.leading)
      }
    }
  }

  private func processResult(
    _ result: Result<some CustomDebugStringConvertible, SeamlessPayError>
  ) {
    inProgress = false
    switch result {
    case let .success(payload):
      displayResult = .init(header: "Success:", payload: payload.debugDescription)
    case let .failure(error):
      displayResult = .init(header: "Failure:", payload: error.localizedDescription)
    }
  }

  private func startProgress() {
    inProgress = true
    displayResult = .init(header: "", payload: "")
  }
}
