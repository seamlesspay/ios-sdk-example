// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import Foundation

import SwiftUI

struct ApplePaySimulatorNotice: ViewModifier {
  @Environment(\.isRunningOnSimulator) var isRunningOnSimulator

  func body(content: Content) -> some View {
    if isRunningOnSimulator {
      VStack(spacing: 8) {
        content
        Text("Note: Apple Pay with an iOS Simulator will not work.")
          .multilineTextAlignment(.center)
          .foregroundColor(.secondary)
      }
    } else {
      content
    }
  }
}

extension View {
  func withApplePaySimulatorNotice() -> some View {
    modifier(ApplePaySimulatorNotice())
  }
}

struct IsRunningOnSimulatorKey: EnvironmentKey {
  static let defaultValue: Bool = {
    #if targetEnvironment(simulator)
      return true
    #else
      return false
    #endif
  }()
}

extension EnvironmentValues {
  var isRunningOnSimulator: Bool {
    get { self[IsRunningOnSimulatorKey.self] }
    set { self[IsRunningOnSimulatorKey.self] = newValue }
  }
}
