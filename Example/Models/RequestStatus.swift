// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI

enum RequestStatus {
  case idle
  case processing
  case success(String)
  case failure(String)

  var header: String {
    switch self {
    case .idle:
      return ""
    case .processing:
      return "Processing..."
    case .success:
      return "Success"
    case .failure:
      return "Failure"
    }
  }

  var payload: String {
    switch self {
    case .idle:
      return ""
    case .processing:
      return ""
    case let .failure(result),
         let .success(result):
      return result
    }
  }

  var inProgress: Bool {
    if case .processing = self {
      return true
    } else {
      return false
    }
  }

  var iconName: String? {
    switch self {
    case .idle:
      return .none
    case .processing:
      return .none
    case .success:
      return "checkmark.circle"
    case .failure:
      return "xmark.circle"
    }
  }

  var color: Color {
    switch self {
    case .idle:
      return .secondary
    case .processing:
      return .secondary
    case .success:
      return .primary
    case .failure:
      return .red
    }
  }
}
