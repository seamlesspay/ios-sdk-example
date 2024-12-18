// **
// * Copyright (c) Seamless Payments, Inc.
// *
// * This source code is licensed under the MIT license found in the
// * LICENSE file in the root directory of this source tree.
// *

import SeamlessPay

extension TokenizeResponse: CustomDebugStringConvertible {
  public var debugDescription: String {
    """
    Payment Method Response:
      - Payment Token: \(paymentToken)
      - Details:
          - Name: \(details.name ?? "N/A")
          - Expiration Date: \(details.expDate ?? "N/A")
          - Last Four: \(details.lastFour ?? "N/A")
          - Expiration Date: \(details.expDate ?? "N/A")
          - Payment Network: \(details.paymentNetwork?.rawValue ?? "N/A")
          - Postal Code AVS Result: \(details.avsPostalCodeResult?.rawValue ?? "N/A")
          - Street Address AVS Result: \(details.avsStreetAddressResult?.rawValue ?? "N/A")
          - CVV AVS Result: \(details.cvvResult?.rawValue ?? "N/A")
    """
  }
}

extension PaymentResponse: CustomDebugStringConvertible {
  public var debugDescription: String {
    """
    Payment Response:
      - ID: \(id)
      - Payment Token: \(paymentToken)
      - Details:
          - Amount: \(details.amount?.description ?? "N/A")
          - Auth Code: \(details.authCode ?? "N/A")
          - Batch ID: \(details.batchId ?? "N/A")
          - Last Four: \(details.lastFour ?? "N/A")
          - Card Brand: \(details.cardBrand?.rawValue ?? "N/A")
          - Status: \(details.status?.rawValue ?? "N/A")
          - Status Code: \(details.statusCode ?? "N/A")
          - Status Description: \(details.statusDescription ?? "N/A")
          - Transaction Date: \(details.transactionDate ?? "N/A")
          - Surcharge Fee Amount Description: \(details.surchargeFeeAmount?.description ?? "N/A")
          - Postal Code AVS Result: \(details.avsPostalCodeResult?.rawValue ?? "N/A")
          - Street Address AVS Result: \(details.avsStreetAddressResult?.rawValue ?? "N/A")
          - CVV AVS Result: \(details.cvvResult?.rawValue ?? "N/A")
          - Account Type: \(details.accountType?.rawValue ?? "N/A")
          - Currency: \(details.currency?.rawValue ?? "N/A")
          - Expiration Date: \(details.expDate ?? "N/A")
          - Tip: \(details.tip?.description ?? "N/A")
    """
  }
}
