// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI

struct CopyButton: View {
  let textToCopy: String
  @State private var showCopiedFeedback = false

  var body: some View {
    Button {
      UIPasteboard.general.string = textToCopy
      showCopiedFeedback = true

      Task { @MainActor in
        try? await Task.sleep(for: .seconds(1.5))
        showCopiedFeedback = false
      }
    } label: {
      HStack {
        Image(systemName: showCopiedFeedback ? "checkmark" : "doc.on.doc")
        Text(showCopiedFeedback ? "Copied!" : "Copy Response")
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 8)
    }
    .buttonStyle(.borderless)
    .padding(.horizontal)
    .animation(.easeInOut, value: showCopiedFeedback)
  }
}

#Preview {
  CopyButton(textToCopy: "Hello, world!")
    .padding()
}
    
