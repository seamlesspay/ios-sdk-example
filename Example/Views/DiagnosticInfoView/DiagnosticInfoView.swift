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
  private var diagnosticData: DiagnosticData

  init(
    environment: SeamlessPay.Environment,
    secretKey: String,
    proxyAccountId: String?,
    contentType: Binding<ContentType?>
  ) {
    _contentType = contentType
    
    diagnosticData = .init(
      sdkVersion: SeamlessPaySDK.version,
      secretKey: secretKey,
      proxyAccountId: proxyAccountId,
      environment: environment
    )
  }
  
  var body: some View {
    VStack(spacing: 32) {
      diagnosticInfoSection()
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(spTableBackgroundColor)
        .cornerRadius(8)
      Spacer()
      CopyButton(
        title: "Copy Info",
        textToCopy: diagnosticData.copyDiagnosticInfo
      )
    }
    .padding()
    .navigationTitle("Diagnostic Info")
    .navigationBarTitleDisplayMode(.inline)
    .background(Color(UIColor.systemGroupedBackground))
    .withDoneNavigation(contentType: $contentType)
  }
  
  @ViewBuilder
  private func diagnosticInfoSection() -> some View {
    VStack(alignment: .leading, spacing: 12) {
      DiagnosticRow(
        title: "Environment",
        value: String(describing: diagnosticData.environment)
      )
      
      DiagnosticRow(
        title: "Client Secret",
        value: masked(secret: diagnosticData.secretKey)
      )
      
      DiagnosticRow(
        title: "Proxy Account",
        value: diagnosticData.proxyAccountId.map { masked(secret: $0) } ?? "nil"
      )
      
      DiagnosticRow(
        title: "App Version",
        value: diagnosticData.appVersion
      )
      
      DiagnosticRow(
        title: "Build Number",
        value: diagnosticData.buildNumber
      )
      
      DiagnosticRow(
        title: "SDK Version",
        value: diagnosticData.sdkVersion
      )
      
      DiagnosticRow(
        title: "OS Version",
        value: diagnosticData.osVersion
      )
      
      DiagnosticRow(
        title: "Device Model",
        value: diagnosticData.deviceModel
      )
      
      DiagnosticRow(
        title: "Screen Size",
        value: diagnosticData.screenSize
      )
    }
  }
  
  private func masked(secret: String) -> String {
    guard secret.count >= 7 + 4 else { return secret }
    let prefix = String(secret.prefix(7))
    let suffix = String(secret.suffix(4))
    let mask = String(repeating: "*", count: 4)
    return "\(prefix)\(mask)\(suffix)"
  }
}

// MARK: - Diagnostic Data Model
private struct DiagnosticData {
  var appVersion: String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
  }
  
  var buildNumber: String {
    Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
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
    let dpi = Int(scale * 160.0)
    return "\(width)×\(height) @\(dpi)dpi"
  }
  
  let sdkVersion: String
  let secretKey: String
  let proxyAccountId: String?
  let environment: SeamlessPay.Environment
  
  var copyDiagnosticInfo: String {
    let components = [
      "Environment: \(String(describing: environment))",
      "Client Secret: \(secretKey)",
      "Proxy Account: \(proxyAccountId ?? "N/A")",
      "App Version: \(appVersion)",
      "Build Number: \(buildNumber)",
      "SDK Version: \(sdkVersion)",
      "OS Version: \(osVersion)",
      "Device Model: \(deviceModel)",
      "Screen Size: \(screenSize)",
    ]
    
    return components.joined(separator: "\n")
  }
}

// MARK: - Diagnostic Row Component
struct DiagnosticRow: View {
  let title: String
  let value: String
  
  var body: some View {
    HStack {
      Text(title)
        .lineLimit(1)
        .foregroundColor(.primary)
        .multilineTextAlignment(.leading)
        .frame(width: 120, alignment: .leading)
      
      Text(value)
        .lineLimit(1)
        .foregroundColor(.primary)
        .bold()
        .multilineTextAlignment(.leading)
    }
  }
}

#Preview {
  DiagnosticInfoView(
    environment: .qat,
    secretKey: "preview_value",
    proxyAccountId: "preview_value",
    contentType: .constant(.diagnosticInfo)
  )
}
