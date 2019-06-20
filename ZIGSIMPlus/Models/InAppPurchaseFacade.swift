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
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func purchase(completion: ((TransactionResult, Error?) -> Void)?) {
        self.completion = completion
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
        self.completion = completion
        SKPaymentQueue.default().restoreCompletedTransactions()
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
        
        // Dealing only one transaction is assumed
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .failed, .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                didGetTransactionResult(transaction)
                return
            default:
                // Do nothing
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        // When restore fails, there is no transaction in queue
        // So don't need to finish transaction
        completion?(.restoreFailed, error)
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
    }
}
