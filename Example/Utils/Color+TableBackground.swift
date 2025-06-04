// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI

var spTableBackgroundColor: Color {
  Color(
    uiColor: UIColor { (traitCollection: UITraitCollection) -> UIColor in
      if traitCollection.userInterfaceStyle == .dark {
        return .secondarySystemBackground
      } else {
        return .systemBackground
      }
    }
  )
}
