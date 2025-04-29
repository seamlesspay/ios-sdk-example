// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

enum DemoAuth {
  static let secretKey: String = "sk_01D8GYH576BJYWWSJH0E3XZDCZ"
  static let environment: SeamlessPay.Environment = .sandbox
  static let proxyAccountId: String? = .none
}

struct ContentView: View {
  @State private var isDarkMode: Bool = UITraitCollection.current.userInterfaceStyle == .dark
  @State private var contentType: ContentType?
  @State private var path: [String] = []

  var body: some View {
    NavigationStack {
      List {
        Section {
          Toggle("Dark Mode", isOn: $isDarkMode)
        }

        Section {
          Button("Card Form") {
            self.contentType = .cardForm
          }
          .tint(.primary)

          Button {
            self.contentType = .applePay
          } label: {
            Text("Apple Pay Button")
              .withApplePaySimulatorNotice()
          }

        } header: {
          Text("UI Components")
        }
        .tint(.primary)
      }
      .sheet(item: $contentType) { type in
        NavigationStack(path: $path) {
          Group {
            switch type {
            case .cardForm:
              TransactionOptionsView(path: $path)
            case .applePay:
              ApplePayContent(
                config: .init(
                  environment: DemoAuth.environment,
                  secretKey: DemoAuth.secretKey,
                  proxyAccountId: DemoAuth.proxyAccountId
                ),
                path: $path
              )
            }
          }
        }
      }
      .navigationTitle("SDK Examples")
      .onChange(of: isDarkMode) {
        updateAppearance()
      }
      .onAppear {
        updateAppearance()
      }
    }
  }
}

// MARK: Helper
private extension ContentView {
  func updateAppearance() {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      windowScene.windows.forEach { window in
        window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
      }
    }
  }
}

#Preview {
  ContentView()
}
