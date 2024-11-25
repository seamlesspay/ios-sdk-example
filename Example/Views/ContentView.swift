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
                fieldOptions: FieldOptions(
                  cvv: FieldConfiguration(display: .required),
                  postalCode: FieldConfiguration(display: .required)
                ),
                styleOptions: StyleOptions(
                  colors: Colors(
                    light: ColorPalette(
                      theme: ThemeColors(
                        neutral: UIColor(red: 42 / 255, green: 42 / 255, blue: 42 / 255, alpha: 1),
                        primary: UIColor(
                          red: 59 / 255,
                          green: 130 / 255,
                          blue: 246 / 255,
                          alpha: 1
                        ),
                        danger: UIColor(red: 186 / 255, green: 32 / 255, blue: 60 / 255, alpha: 1)
                      )
                    ),
                    dark: ColorPalette(
                      theme: ThemeColors(
                        neutral: UIColor(
                          red: 249 / 255,
                          green: 249 / 255,
                          blue: 249 / 255,
                          alpha: 1
                        ),
                        primary: UIColor(
                          red: 59 / 255,
                          green: 130 / 255,
                          blue: 246 / 255,
                          alpha: 1
                        ),
                        danger: UIColor(red: 207 / 255, green: 102 / 255, blue: 121 / 255, alpha: 1)
                      )
                    )
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
