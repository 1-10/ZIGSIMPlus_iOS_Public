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
            completion?(.purchaseFailed, nil)
        }
    }

    func restorePurchase(completion: ((TransactionResult, Error?) -> Void)?) {
        print("restorePurchase")
        self.completion = completion
        
        // Is this necessary???
        if SKPaymentQueue.canMakePayments() {
            print("User can make payments")
            
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            print("User can't make payments")
            
            completion?(.restoreFailed, nil)
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
            case .purchased, .failed, .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                didGetTransactionResult(transaction)
                return
//            case .restored:
//                print("restored")
            case .purchasing:
                print("purchasing")
            case .deferred:
                print("deferred")
//            default:
//                // Do nothing for .restored, .purchasing, .deferred
//                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        // This delegate method is necessary, because updatedTransactions is not called
        // when restore failed.
        
        // When restore failed, there is no transaction in queue
        completion?(.restoreFailed, error)
    }
    
    // Is this necessary???
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        // This delegate method will be called in the following cases:
        // 1) When restore completed successfully
        // 2) When restore failed
        // In case 1), updatedTransactions is also called.
        // In case 2), restoreCompletedTransactionsFailedWithError or this method is called.

        print("paymentQueueRestoreCompletedTransactionsFinished")

        // Dealing only one transaction is assumed
        for transaction in queue.transactions {
            SKPaymentQueue.default().finishTransaction(transaction)
            didGetTransactionResult(transaction)
            return
        }

        // When restore failed, there is no transaction in queue
        completion?(.restoreFailed, nil)
    }

    func didGetTransactionResult(_ transaction: SKPaymentTransaction) {
        switch transaction.transactionState {
        case .purchased:
            storePurchasedState()
            completion?(.purchaseSuccessful, nil)
        case .failed:
            completion?(.purchaseFailed, transaction.error)
        case .restored:
            storePurchasedState()
            completion?(.restoreSuccessful, nil)
        default:
            break
        }
        
        completion = nil
    }
}
