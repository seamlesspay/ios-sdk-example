// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import Foundation

struct Transaction {
  enum Kind: CaseIterable {
    case tokenizeOnly
    case charge
    case refund
  }

  let kind: Kind
  let amountRaw: String
}

extension Transaction {
  static func charge(amount: String) -> Self {
    .init(kind: .charge, amountRaw: amount)
  }
}

extension Transaction {
  var cents: Int {
    // Convert string to decimal number
    let amount = amountRaw.replacingOccurrences(of: ",", with: ".")
    guard let decimal = Decimal(string: amount) else { return 0 }

    // Multiply by 100 to convert dollars to cents and round to nearest cent
    let cents = decimal * 100
    let result = NSDecimalNumber(decimal: cents).intValue
    return result
  }

  var formattedAmount: String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.currencyCode = "USD"
    let amount = NSNumber(value: Double(cents) / 100.0)
    return numberFormatter.string(from: amount) ?? "$0.00"
  }
}
