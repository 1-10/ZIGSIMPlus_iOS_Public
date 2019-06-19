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
        case purchased
        case restored
        case failed
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
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .failed, .restored:
                didGetTransactionResult(transaction)
                return
            default:
                // Do nothing
                break
            }
        }
    }

    func didGetTransactionResult(_ transaction: SKPaymentTransaction) {
        // Do not finishTransaction here, or unit test fails when transactionState == .inpurchase
        // Call finishTransaction for specified transactionState
        
        switch transaction.transactionState {
        case .purchased:
            SKPaymentQueue.default().finishTransaction(transaction)
            storePurchasedState()
            completion?(.purchased, nil)
        case .failed:
            SKPaymentQueue.default().finishTransaction(transaction)
            completion?(.failed, transaction.error)
        case .restored:
            SKPaymentQueue.default().finishTransaction(transaction)
            storePurchasedState()
            completion?(.restored, nil)
        default:
            break
        }
    }
}
