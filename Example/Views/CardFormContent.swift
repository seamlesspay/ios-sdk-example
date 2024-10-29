// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

struct CardFormContent: View {
  @State var displayResult: DisplayResult = .init(header: "", payload: "")
  @State var inProgress: Bool = false

  let header: String
  let cardFromRepresentable: AnyView
  let tokenize: (((Result<TokenizeResponse, SeamlessPayError>?) -> Void)?) -> Void
  let charge: (
    _ request: ChargeRequest,
    ((Result<PaymentResponse, SeamlessPayError>?) -> Void)?
  ) -> Void
  let refund: (
    _ request: RefundRequest,
    ((Result<PaymentResponse, SeamlessPayError>?) -> Void)?
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

        Text(displayResult.header)
          .lineLimit(1)
          .fontWeight(.bold)
        if inProgress {
          ProgressView()
            .frame(
              maxWidth: .infinity,
              alignment: .center
            )
        } else {
          Text(displayResult.payload)
            .multilineTextAlignment(.leading)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .center)
  }

  private func processResult(
    _ result: Result<some CustomDebugStringConvertible, SeamlessPayError>?
  ) {
    inProgress = false
    switch result {
    case let .success(payload):
      displayResult = .init(header: "Success", payload: payload.debugDescription)
    case let .failure(error):
      displayResult = .init(header: "Failure", payload: error.localizedDescription)
    default:
      displayResult = .init(header: "", payload: "")
    }
  }

  private func startProgress() {
    inProgress = true
    displayResult = .init(header: "", payload: "")
  }
}

#Preview {
  CardFormContent(
    header: "Multiline Card Form",
    cardFromRepresentable: AnyView(
      MultiLineCardFormUI(
        cardForm: MultiLineCardForm(
          config: .init(
            environment: .sandbox,
            secretKey: "sk_x"
          ),
          fieldOptions: .init(cvv: .init(display: .required), postalCode: .init(display: .required)),
          styleOptions: .default
        )
      )
    ),
    tokenize: { completion in

    },
    charge: { _, completion in

    },
    refund: { _, completion in
    }
  )
}
