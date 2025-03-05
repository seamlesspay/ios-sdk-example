// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

enum DemoAuth {
  static let secretKey: String = "sk_XXXXXXXXXXXXXXXXXXXXXXXXXX"
  static let environment: SeamlessPay.Environment = .staging
  static let proxyAccountId: String? = "MRT_XXXXXXXXXXXXXXXXXXXXXXXXXX"
}

struct ContentView: View {
  @State private var contentType: ContentType?

  var body: some View {
    NavigationView {
      List {
        Section {
<<<<<<< HEAD
          Button("SingleLine Card Form") {
            self.contentType = .single
          }
          Button("Multiline Card Form") {
            self.contentType = .multi
=======
          Button("Card Form") {
            self.contentType = .cardForm
>>>>>>> 99f348d (feat: [EXI-19] Update card form components; replace MultiLineCardForm with CardForm and update related references)
          }
          Button {
            self.contentType = .applePay
          } label: {
            Text("Apple Pay Button")
              .withApplePaySimulatorNotice()
          }
        } header: {
          Text("UI Components")
        }
      }
      .sheet(item: $contentType) { contentType in
        NavigationStack {
          Group {
            switch contentType {
<<<<<<< HEAD
            case .single:
              SingleLineCardFormContent(
                config: .init(
                  environment: DemoAuth.environment,
                  secretKey: DemoAuth.secretKey,
                  proxyAccountId: DemoAuth.proxyAccountId
                ),
                fieldOptions: .default
              )
            case .multi:
              MultiLineCardFormContent(
=======
            case .cardForm:
              CardFormContent(
                header: "Card Form",
>>>>>>> 99f348d (feat: [EXI-19] Update card form components; replace MultiLineCardForm with CardForm and update related references)
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
            case .applePay:
              ApplePayContent(
                config: .init(
                  environment: DemoAuth.environment,
                  secretKey: DemoAuth.secretKey,
                  proxyAccountId: DemoAuth.proxyAccountId
                )
              )
            }
          }
          .navigationBarItems(
            trailing: Button("Done") {
              self.contentType = .none
            }
          )
        }
      }
      .navigationTitle("SeamlessPay UI Demo")
    }
  }
}

#Preview {
  ContentView()
}
