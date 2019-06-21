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
    
    var completion: ((TransactionResult, Error?) -> Void)?
    let timeoutForRestore: Double = 10.0
    
    func purchase(completion: ((TransactionResult, Error?) -> Void)?) {
        self.completion = completion
        SKPaymentQueue.default().add(self)
        if SKPaymentQueue.canMakePayments() {
            print("User can make payments")
            
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productId
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("User can't make payments")
            
            completion?(.purchaseFailed, nil)
        }
    }

    func restorePurchase(completion: ((TransactionResult, Error?) -> Void)?) {
        print("restorePurchase")
        self.completion = completion
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeoutForRestore) {
            print("timeout")
            for transaction in SKPaymentQueue.default().transactions {
                print("clear unfinished transaction")
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            
            SKPaymentQueue.default().remove(self)
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
            case .purchased, .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                didGetTransactionResult(transaction)
                return
            case .restored:
                print("restored")
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
        // When restore fails, there is no transaction in queue
        print("restoreCompletedTransactionsFailedWithError")
        completion?(.restoreFailed, error)
    }
    
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

        // When restore fails, there is no transaction in queue
        if let completion = completion {
            print("completion not nil")
            completion(.restoreFailed, nil)
        } else {
            print("completion nil")
        }
    }

    func didGetTransactionResult(_ transaction: SKPaymentTransaction) {
        print("didGetTransactionResult")
        
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
    }
}
