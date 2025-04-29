// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI

struct StatusHeader: View {
  let kind: PaymentResponseResult.Kind

  var body: some View {
    HStack {
      switch kind {
      case .success:
        Image(systemName: "checkmark.circle")
          .foregroundColor(.white)
          .font(.system(size: 24))
        Text("Success")
          .foregroundColor(.white)
      case .failure:
        Image(systemName: "xmark.circle")
          .foregroundColor(.white)
          .font(.system(size: 24))
        Text("Error")
          .foregroundColor(.white)
      }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      Group {
        switch kind {
        case .success:
          Color.green
        case .failure:
          Color.red
        }
      }
    )
    .cornerRadius(8)
  }
}

#Preview("Success And Failure Status Header") {
  Group {
    StatusHeader(kind: .success)
    StatusHeader(kind: .failure)
  }
  .padding()
}
