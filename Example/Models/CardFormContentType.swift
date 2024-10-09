// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import Foundation

enum CardFormContentType: String, Identifiable {
  var id: String {
    rawValue
  }

  case single
  case multi
}