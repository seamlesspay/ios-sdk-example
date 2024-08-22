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
  @State private var cardFormContentType: CardFormContentType?

  var body: some View {
    NavigationView {
      List {
        Section {
          Text("Singleline Card Form")
            .onTapGesture {
              self.cardFormContentType = .single
            }
          Text("Multiline Card Form")
            .onTapGesture {
              self.cardFormContentType = .multi
            }
        } header: {
          Text("UI Components")
        }
      }
      .sheet(item: $cardFormContentType) { contentType in
        NavigationStack {
          CardFormContent(
            config: .init(
              environment: DemoAuth.environment,
              secretKey: DemoAuth.secretKey,
              proxyAccountId: DemoAuth.proxyAccountId
            ),
            type: contentType
          )
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
