//
//  InAppPurchaseFacade.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/06/18.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
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
    private override init () { super.init() }
    var completion: ((TransactionResult, Error?) -> Void)?
    
    func purchase(completion: ((TransactionResult, Error?) -> Void)?) {
        self.completion = completion
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productId
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

extension InAppPurchaseFacade: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("updatedTransactions")
        
        // Dealing only one transaction is assumed
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                didGetTransactionResult(transaction)
                return
            case .restored:
                // TODO: Check Product ID
                
                // Deal with .restored here, not in "paymentQueueRestoreCompletedTransactionsFinished"
                // See: https://stackoverflow.com/questions/14309427/paymentqueuerestorecompletedtransactionsfinished-vs-updatedtransactions
                SKPaymentQueue.default().finishTransaction(transaction)
                didGetTransactionResult(transaction)
                return
            default:
                // Do nothing for .purchasing, .deferred
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        // This delegate method is necessary, because updatedTransactions is not called
        // when restore failed.
        
        // When restore failed, there is no transaction to finish in queue
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
        completion?(result, nil)
        completion = nil
    }
}
