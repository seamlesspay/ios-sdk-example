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

      VStack(spacing: 16) {
        Text(status.header)
          .lineLimit(1)
          .fontWeight(.bold)
          .foregroundColor(status.color)
        if status.inProgress {
          ProgressView()
            .frame(
              maxWidth: .infinity,
              alignment: .center
            )
            .foregroundColor(status.color)
        } else {
          Text(status.payload)
            .multilineTextAlignment(.leading)
        }

        HStack {
          actionButton(title: "Tokenize") {
            tokenize {
              processResult($0)
            }
          }
          actionButton(title: "Pay") {
            charge(ChargeRequest(amount: 100)) {
              processResult($0)
            }
          }
          actionButton(title: "Refund") {
            refund(RefundRequest(amount: 100)) {
              processResult($0)
            }
          }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .center)
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
    _ result: Result<some CustomDebugStringConvertible, SeamlessPayError>?
  ) {
    withAnimation {
      switch result {
      case let .success(payload):
        status = .success(payload.debugDescription)
      case let .failure(error):
        status = .failure(error.localizedDescription)
      default:
        status = .idle
      }
    }
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
          fieldOptions: .init(
            cvv: .init(display: .required),
            postalCode: .init(display: .required)
          ),
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
