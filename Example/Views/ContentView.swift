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
  enum AppStorageKeys {
    static let isDarkMode = "isDarkMode"
  }
  
  @AppStorage(AppStorageKeys.isDarkMode) private var isDarkMode = {
    if UserDefaults.standard.object(forKey: AppStorageKeys.isDarkMode) == nil {
      return UITraitCollection.current.userInterfaceStyle == .dark
    }
    return UserDefaults.standard.bool(forKey: AppStorageKeys.isDarkMode)
  }()

  @State private var contentType: ContentType?

  var body: some View {
    NavigationView {
      List {
        Section {
          Toggle("Dark mode", isOn: $isDarkMode)
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
        NavigationStack {
          sheetContent(for: type)
            .navigationBarItems(
              trailing: Button("Done") {
                self.contentType = .none
              }
            )
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
  
  @ViewBuilder
  private func sheetContent(for contentType: ContentType) -> some View {
    switch contentType {
    case .cardForm:
      CardFormContent(
        header: "Card Form",
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
