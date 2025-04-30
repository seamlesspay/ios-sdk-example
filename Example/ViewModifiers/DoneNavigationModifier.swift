// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SwiftUI

struct DoneNavigationModifier: ViewModifier {
  @Binding var contentType: ContentType?

  func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") {
            contentType = .none
          }
        }
      }
  }
}

extension View {
  func withDoneNavigation(contentType: Binding<ContentType?>) -> some View {
    modifier(DoneNavigationModifier(contentType: contentType))
  }
}
