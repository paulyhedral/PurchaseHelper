//
//  PurchaseHelper.swift
//  PurchaseHelper
//
//  Created by Paul Schifferer on 9/3/14.
//  Copyright (c) 2019 Pilgrimage Software. All rights reserved.
//

import Foundation
import StoreKit
import SAMKeychain


public let ProductPurchasedNotification = NSNotification.Name("ProductPurchased")
public let ProductPurchaseCanceledNotification = NSNotification.Name("ProductPurchaseCanceled")
public let ProductPurchasedNotificationProductIdentifierKey = "product"

public typealias RequestProductsCompletionHandler = (Bool, [SKProduct]) -> Void
public typealias RequestProductInfoCompletionHandler = (Bool, SKProduct?) -> Void

public class PurchaseHelper : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    public let productIdentifiers : Set<ProductIdentifier>
    public let keychainAccount : String
    public var testMode : Bool = false

    private var productsRequest : SKProductsRequest?
    private var completionHandler : RequestProductsCompletionHandler?
    private var purchasedProductIdentifiers : Set<ProductIdentifier> = []
    private var products : [ProductIdentifier : SKProduct] = [:]
    private var productEquivalenceMap : [ProductIdentifier : [ProductIdentifier]] = [:]


    public override init() {
        NSException().raise()
    }

    public init(productIdentifiers : Set<ProductIdentifier>, keychainAccount : String) {
        self.productIdentifiers = productIdentifiers
        self.keychainAccount = keychainAccount

        #if os(iOS)
        SAMKeychain.setAccessibilityType(kSecAttrAccessibleAlways)
        #endif

        if let purchases = SAMKeychain.accounts(forService: self.keychainAccount) {
            for purchaseDict in purchases {
                guard let productId = purchaseDict[kSecAttrAccount as String] as? String else { continue }

                NSLog("Previously purchased: \(productId)")
                purchasedProductIdentifiers.insert(ProductIdentifier(stringLiteral: productId))
            }
        }

        SKPaymentQueue.default().add(self)
    }


    // MARK: - Worker methods

    private func complete(transaction : SKPaymentTransaction) {
        NSLog("Completing transaction: \(transaction)")

        let productId = ProductIdentifier(stringLiteral: transaction.payment.productIdentifier)
        self.provideContent(for: transaction, productIdentifier: productId)

        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func handle(failedTransaction transaction : SKPaymentTransaction) {
        NSLog("Handling failed transaction \(transaction)")

//        if let error = transaction.error,
//            error.code != .cancelled {
//            NSLog("Transaction error: \(error)")
//        }

        NotificationCenter.default.post(name: ProductPurchaseCanceledNotification,
                                        object: self,
                                        userInfo: [
                                            ProductPurchasedNotificationProductIdentifierKey : transaction.payment.productIdentifier,
                                            ])

        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func restore(transaction : SKPaymentTransaction) {
        NSLog("Restoring transaction \(transaction)")

        self.provideContent(for: transaction, productIdentifier: ProductIdentifier(stringLiteral: transaction.payment.productIdentifier))

        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func provideContent(for transaction : SKPaymentTransaction, productIdentifier : ProductIdentifier) {

        self.purchasedProductIdentifiers.insert(productIdentifier)

        SAMKeychain.setPassword(transaction.transactionIdentifier,
                                forService: self.keychainAccount,
                                account: productIdentifier.id.rawValue)

        NotificationCenter.default.post(name: ProductPurchasedNotification,
                                        object:self,
                                        userInfo: [
                                            ProductPurchasedNotificationProductIdentifierKey : productIdentifier,
                                            ])
    }


    // MARK: - Public API

    public func requestProducts(with completionHandler : @escaping RequestProductsCompletionHandler) {

        guard self.productsRequest == nil else {
            NSLog("Product request is already in progress!")
            return
        }

        guard !self.testMode else {
            NSLog("Bypassing actual request, because helper is in test mode.")
            completionHandler(true, [])
            return
        }

        NSLog("Starting products request...")

        let productIds = Set<String>(self.productIdentifiers.map { $0.id.rawValue })
        self.productsRequest = SKProductsRequest(productIdentifiers: productIds)
        self.completionHandler = completionHandler

        //    NSString* requestKey = [NSString stringWithFormat:@"%p", _productsRequest];
        //    _requestMap[requestKey] = _productsRequest;
        //    _handlerMap[requestKey] = [completionHandler copy];

        self.productsRequest?.delegate = self
        self.productsRequest?.start()
    }

    public func buy(productIdentifier : ProductIdentifier) {
        NSLog("Buying \(productIdentifier)...")

        guard !self.testMode else {
            NSLog("Bypassing product purchase, because helper is in test mode.")
            return
        }

        guard let product = self.products[productIdentifier] else {
            NSLog("Product not found for \(productIdentifier).")
            return
        }

        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    public func isProductPurchased(productIdentifier : ProductIdentifier) -> Bool {

        guard !self.testMode else {
            NSLog("Returning true for purchase check, because helper is in test mode.")
            return true
        }

        var productId = productIdentifier.id.rawValue

        // check for item on keychain
        var transactionId = SAMKeychain.password(forService: self.keychainAccount,
                                                           account: productId)

        if transactionId == nil,
            let equivalents = self.productEquivalenceMap[productIdentifier] {
            for equivalentId in equivalents {
                if let tId = SAMKeychain.password(forService: self.keychainAccount,
                                                  account: equivalentId.id.rawValue) as? String {
                    transactionId = tId
                    productId = equivalentId.id.rawValue
                    break
                }
            }
        }

        guard transactionId != nil else { return false }

        return self.purchasedProductIdentifiers.contains(ProductIdentifier(stringLiteral: productId))
    }

    public func restoreCompletedTransactions() {
        guard !self.testMode else {
            NSLog("Ignoring restore request, because helper is in test mode.")
            return
        }

        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    public func productInfo(_ productIdentifier : ProductIdentifier) -> SKProduct? {
        return self.products[productIdentifier]
    }

    public func clearPurchaseHistory() {
        guard !self.testMode else {
            NSLog("Ignoring clear request, because helper is in test mode.")
            return
        }

        for productId in self.productIdentifiers {
            SAMKeychain.deletePassword(forService: self.keychainAccount,
                                                 account: productId.id.rawValue)
            self.purchasedProductIdentifiers.remove(productId)
        }
    }


    // MARK: - Store Kit delegate methods

    public func productsRequest(_ request : SKProductsRequest, didReceive response : SKProductsResponse) {
        NSLog("Loaded list of products...")

        for product in response.products {
            let productId = ProductIdentifier(stringLiteral: product.productIdentifier)
            self.products[productId] = product
            NSLog("Found product: \(product.productIdentifier) \(product.localizedTitle) \(product.price.floatValue)")
        }

        self.completionHandler?(true, Array<ProductIdentifier>(products.values))
    }

    public func request(_ request : SKRequest, didFailWithError error : Error) {
        self.productsRequest = nil

        self.completionHandler?(false, [])
    }

    public func paymentQueue(_ queue : SKPaymentQueue, restoreCompletedTransactionsFailedWithError error : Error) {
        NSLog("Restore transactions failed: \(error)")

        // TODO?
    }

    public func paymentQueue(_ queue : SKPaymentQueue, updatedTransactions transactions : [SKPaymentTransaction]) {
        for tx in transactions {
            switch tx.transactionState {
            case .purchased:
                self.complete(transaction: tx)

            case .failed:
                self.handle(failedTransaction: tx)

            case .restored:
                self.restore(transaction: tx)

            default: break
            }
        }
    }

    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue : SKPaymentQueue) {
        NSLog("\(#function)")
    }

}
