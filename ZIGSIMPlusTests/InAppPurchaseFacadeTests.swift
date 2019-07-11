//
//  InAppPurchaseTests.swift
//  ZIGSIMPlusFacadeTests
//
//  Created by Nozomu Kuwae on 2019/06/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import XCTest
import StoreKit
@testable import ZIGSIMPlus

class InAppPurchaseFacadeTests: XCTestCase {
    private let purchaseFacade = InAppPurchaseFacade.shared

    override func setUp() {
        UserDefaults.standard.removeObject(forKey: "com.OneToTen.ZIGSIMPlusExplicit.PremiumFeatures")
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "com.OneToTen.ZIGSIMPlusExplicit.PremiumFeatures")
    }

    func testDidGetTransactionResult_WhenSuccessful() {
        let testCases = [
            (SKPaymentTransactionState.purchased, InAppPurchaseFacade.TransactionResult.purchaseSuccessful),
            (SKPaymentTransactionState.restored, InAppPurchaseFacade.TransactionResult.restoreSuccessful)
        ]

        for testCase in testCases {
            setUp()
            XCTAssertFalse(purchaseFacade.isPurchased())

            let exp = expectation(description: "Purchase premium features successful")
            purchaseFacade.completion = { (result, error) in
                XCTAssertEqual(result, testCase.1)
                XCTAssertNil(error)
                XCTAssertTrue(self.purchaseFacade.isPurchased())
                exp.fulfill()
                self.tearDown()
            }

            let transactionMock = PaymentTransactionMock()
            transactionMock.transactionState = testCase.0
            purchaseFacade.didGetTransactionResult(transactionMock)

            wait(for: [exp], timeout: 3.0)
        }
    }

    func testtDidGetTransactionResult_WhenFailed() {
        XCTAssertFalse(purchaseFacade.isPurchased())

        let exp = expectation(description: "Purchase premium features failed")
        purchaseFacade.completion = { (result, error) in
            XCTAssertEqual(result, .purchaseFailed)
            XCTAssertFalse(self.purchaseFacade.isPurchased())
            exp.fulfill()
        }

        let transactionMock = PaymentTransactionMock()
        transactionMock.transactionState = .failed
        purchaseFacade.didGetTransactionResult(transactionMock)

        wait(for: [exp], timeout: 3.0)
    }

    func testDidGetTransactionResult_WhenInProcess() {
        let testCases = [
            SKPaymentTransactionState.deferred,
            SKPaymentTransactionState.purchasing
        ]

        for testCase in testCases {
            setUp()
            XCTAssertFalse(purchaseFacade.isPurchased())

            let exp = expectation(description: "Purchase premium features in process")
            exp.isInverted = true

            purchaseFacade.completion = { (result, error) in
                print("result: \(result)")
                exp.fulfill()
            }

            let transactionMock = PaymentTransactionMock()
            transactionMock.transactionState = testCase
            purchaseFacade.didGetTransactionResult(transactionMock)

            wait(for: [exp], timeout: 3.0)
            tearDown()
        }
    }
}

class PaymentTransactionMock: SKPaymentTransaction {
    var _transactionState: SKPaymentTransactionState = .deferred

    override var transactionState: SKPaymentTransactionState {
        get {
            return _transactionState
        }
        set {
            _transactionState = newValue
        }
    }
}
