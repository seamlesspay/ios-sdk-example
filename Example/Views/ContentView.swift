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
          Button("Multiline Card Form") {
            self.contentType = .cardForm
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
            case .cardForm:
              MultiLineCardFormContent(
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
