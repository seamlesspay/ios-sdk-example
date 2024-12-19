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

  private let unifiedColorPalette: ColorPalette = {
    let cornerRadius: CGFloat = 5.0

    let primaryColor = UIColor(
      red: 59 / 255,
      green: 130 / 255,
      blue: 246 / 255,
      alpha: 1
    )

    let dangerColor = UIColor(
      red: 207 / 255,
      green: 102 / 255,
      blue: 121 / 255,
      alpha: 1
    )

    let neutralColor = UIColor(
      red: 42 / 255,
      green: 42 / 255,
      blue: 42 / 255,
      alpha: 1
    )

    return .init(
      theme: ThemeColors(
        neutral: neutralColor,
        primary: primaryColor,
        danger: dangerColor
      ),
      fieldColors: .init(
        background: .init(
          inactive: .systemGray6,
          focusValid: .systemGray6,
          focusInvalid: .systemGray6,
          invalid: .systemGray6
        ),
        hint: .none,
        icon: .none,
        label: .none,
        outline: .none,
        text: .none
      ),
      errorMessage: dangerColor,
      header: neutralColor
    )
  }()

  var body: some View {
    NavigationView {
      List {
        Section {
          Button("SingleLine Card Form") {
            self.contentType = .single
          }
          Button("Multiline Card Form") {
            self.contentType = .multi
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
                fieldOptions: FieldOptions(
                  cvv: FieldConfiguration(display: .required),
                  postalCode: FieldConfiguration(display: .required)
                ),
                styleOptions: StyleOptions(
                  colors: Colors(
                    light: unifiedColorPalette,
                    dark: unifiedColorPalette
                  ),
                  shapes: Shapes(
                    cornerRadius: 5.0
                  ),
                  typography: Typography(
                    font: UIFont.systemFont(ofSize: 18),
                    scale: 1.0
                  ),
                  iconSet: .none
                )
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
