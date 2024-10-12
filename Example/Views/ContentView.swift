// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

enum DemoAuth {
  static let secretKey: String = "sk_01HV75FH87CCT098427ZVEKQHZ"
  static let environment: SeamlessPay.Environment = .staging
  static let proxyAccountId: String? = .none
}

struct ContentView: View {
  @State private var cardFormContentType: CardFormContentType? = .multi

  var body: some View {
    NavigationView {
      List {
        Section {
          Button("SingleLine Card Form") {
            self.cardFormContentType = .single
          }
          Button("Multiline Card Form") {
            self.cardFormContentType = .multi
          }
        } header: {
          Text("UI Components")
        }
      }
      .sheet(item: $cardFormContentType) { contentType in
        NavigationStack {
          Group {
            switch contentType {
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
                config: .init(
                  environment: DemoAuth.environment,
                  secretKey: DemoAuth.secretKey,
                  proxyAccountId: DemoAuth.proxyAccountId
                ),
                fieldOptions: .default
              )
            }
          }
          .navigationBarItems(
            trailing: Button("Done") {
              self.cardFormContentType = .none
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
