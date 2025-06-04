// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI
import SeamlessPay

// MARK: - Diagnostic Info View
struct DiagnosticInfoView: View {
  @Binding var contentType: ContentType?
  
  private let environment: SeamlessPay.Environment
  private let secretKey: String
  private let proxyAccountId: String?
  
  init(
    environment: SeamlessPay.Environment,
    secretKey: String,
    proxyAccountId: String?,
    contentType: Binding<ContentType?>
  ) {
    self.environment = environment
    self.secretKey = secretKey
    self.proxyAccountId = proxyAccountId
    _contentType = contentType
  }
  
  var body: some View {
    VStack(spacing: 32) {
      VStack(alignment: .leading, spacing: 8) {
        DiagnosticRow(title: "Environment", value: String(describing: environment))
        DiagnosticRow(title: "Client Secret", value: masked(secret: secretKey))
        DiagnosticRow(
          title: "Proxy Account",
          value: proxyAccountId.flatMap(masked(secret:)) ?? "N/A"
        )
        DiagnosticRow(title: "App Version", value: appVersion)
        DiagnosticRow(title: "Build Number", value: buildNumber)
        DiagnosticRow(title: "SDK Version", value: sdkVersion)
        DiagnosticRow(title: "OS Version", value: osVersion)
        DiagnosticRow(title: "Device Model", value: deviceModel)
        DiagnosticRow(title: "Screen Size", value: screenSize)
      }
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(spTableBackgroundColor)
      .cornerRadius(8)
      
      Spacer()
      CopyButton(title: "Copy Info", textToCopy: copyDiagnosticInfo)
    }
    .padding()
    .navigationTitle("Diagnostic Info")
    .navigationBarTitleDisplayMode(.inline)
    .background(Color(UIColor.systemGroupedBackground))
    .withDoneNavigation(contentType: $contentType)
  }
}

// MARK: - Diagnostic Data
private extension DiagnosticInfoView {
  func masked(secret: String) -> String {
    guard secret.count >= 8 else { return secret }
    let prefix = String(secret.prefix(4))
    let suffix = String(secret.suffix(4))
    let mask = String(repeating: "*", count: 4)
    return "\(prefix)\(mask)\(suffix)"
  }
  
  var appVersion: String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
  }
  
  var buildNumber: String {
    Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
  }
  
  var sdkVersion: String {
    SeamlessPaySDK.version
  }
  
  var osVersion: String {
    let systemVersion = UIDevice.current.systemVersion
    return "iOS \(systemVersion)"
  }
  
  var deviceModel: String {
    UIDevice.current.name
  }
  
  var screenSize: String {
    let bounds = UIScreen.main.bounds
    let scale = UIScreen.main.scale
    let width = Int(bounds.width * scale)
    let height = Int(bounds.height * scale)
    let dpi = Int(scale * 160) // Approximate DPI calculation
    return "\(width)x\(height) @\(dpi)dpi"
  }
  
  var copyDiagnosticInfo: String {
    """
    Environment: \(String(describing: environment))
    Client Secret: \(secretKey)
    Proxy Account: \(proxyAccountId ?? "N/A")
    App Version: \(appVersion)
    Build Number: \(buildNumber)
    SDK Version: \(sdkVersion)
    OS Version: \(osVersion)
    Device Model: \(deviceModel)
    Screen Size: \(screenSize)
    """
  }
}

// MARK: - Diagnostic Row Component
struct DiagnosticRow: View {
  let title: String
  let value: String
  
  var body: some View {
    HStack {
      Text(title)
        .foregroundColor(.primary)
      Spacer()
      Text(value)
        .foregroundColor(.primary)
        .bold()
        .multilineTextAlignment(.trailing)
    }
  }
}
