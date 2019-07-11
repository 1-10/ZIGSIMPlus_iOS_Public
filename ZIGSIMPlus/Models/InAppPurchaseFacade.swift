//
//  InAppPurchaseFacade.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/06/18.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import StoreKit

class InAppPurchaseFacade: NSObject {
    enum TransactionResult {
        case purchaseSuccessful
        case purchaseFailed
        case restoreSuccessful
        case restoreFailed
    }

    static let shared: InAppPurchaseFacade = InAppPurchaseFacade()
    private override init() { super.init() }
    var completion: ((TransactionResult, Error?) -> Void)?
    var productRequest: SKProductsRequest?

    func purchase(completion: ((TransactionResult, Error?) -> Void)?) {
        self.completion = completion
        if SKPaymentQueue.canMakePayments() {
            // Query the App Store for product information before starting purchase
            // See: https://developer.apple.com/library/archive/technotes/tn2387/_index.html
            productRequest = SKProductsRequest(productIdentifiers: Set([productId]))
            productRequest?.delegate = self
            productRequest?.start()
        } else {
            executeCompletionHandler(result: .purchaseFailed, error: nil)
        }
    }

    func restorePurchase(completion: ((TransactionResult, Error?) -> Void)?) {
        self.completion = completion

        // This "canMakePayments" is necessary.
        // See: https://stackoverflow.com/questions/28734890/restore-inapp-purchase-using-swift-ios
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            executeCompletionHandler(result: .restoreFailed, error: nil)
        }
    }

    func isPurchased() -> Bool {
        return UserDefaults.standard.bool(forKey: productId)
    }

    private func storePurchasedState() {
        UserDefaults.standard.set(true, forKey: productId)
    }

    private var productId: String {
        guard let id = (Bundle.main.infoDictionary?["ProductIDForPremiumFeatures"] as? String) else {
            fatalError("Product ID not defined")
        }

        return id
    }
}

extension InAppPurchaseFacade: SKProductsRequestDelegate {
    func productsRequest(_: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("didReceive")
        productRequest?.delegate = nil

        if response.products.count > 0 {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productId
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            executeCompletionHandler(result: .purchaseFailed, error: nil)
        }
    }

    func request(_: SKRequest, didFailWithError error: Error) {
        print("didFailWithError")
        productRequest?.delegate = nil
        executeCompletionHandler(result: .purchaseFailed, error: error)
    }
}

extension InAppPurchaseFacade: SKPaymentTransactionObserver {
    func paymentQueue(_: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("updatedTransactions")

        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                // Deal with .restored here, not in "paymentQueueRestoreCompletedTransactionsFinished"
                // See: https://stackoverflow.com/questions/14309427/paymentqueuerestorecompletedtransactionsfinished-vs-updatedtransactions
                // swiftlint:disable:previous line_length

                SKPaymentQueue.default().finishTransaction(transaction)

                // In case that other purchase is contained, skip it.
                if transaction.payment.productIdentifier == productId {
                    didGetTransactionResult(transaction)
                }
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                didGetTransactionResult(transaction)
            default:
                // Do nothing for .purchasing, .deferred
                break
            }
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        // This delegate method is necessary, because updatedTransactions is not called
        // when restore failed.
        print("restoreCompletedTransactionsFailedWithError")

        for transaction in queue.transactions {
            SKPaymentQueue.default().finishTransaction(transaction)
        }
        executeCompletionHandler(result: .restoreFailed, error: error)
    }

    func didGetTransactionResult(_ transaction: SKPaymentTransaction) {
        switch transaction.transactionState {
        case .purchased:
            storePurchasedState()
            executeCompletionHandler(result: .purchaseSuccessful, error: nil)
        case .failed:
            executeCompletionHandler(result: .purchaseFailed, error: transaction.error)
        case .restored:
            storePurchasedState()
            executeCompletionHandler(result: .restoreSuccessful, error: nil)
        default:
            break
        }
    }

    private func executeCompletionHandler(result: TransactionResult, error: Error?) {
        completion?(result, error)
        completion = nil
    }
}
