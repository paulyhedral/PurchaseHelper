//
//  RPGPurchaseHelper.h
//  RPGKit
//
//  Created by Paul Schifferer on 9/3/14.
//  Copyright (c) 2014 Pilgrimage Software. All rights reserved.
//

@import Foundation;
@import StoreKit;


typedef void (^RequestProductsCompletionHandler)(BOOL success,  NSArray* _Nonnull products);

UIKIT_EXTERN NSString* const ProductPurchasedNotification;
UIKIT_EXTERN NSString* const ProductPurchasedNotificationProductIdentifierKey;

@interface PurchaseHelper : NSObject
<SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, nonnull, copy) NSString* keychainAccount;

- (nonnull instancetype)initWithProductIdentifiers:(nonnull NSSet*)productIdentifiers
                           keychainAccount:(nonnull NSString*)keychainAccount NS_DESIGNATED_INITIALIZER;

- (void)requestProductsWithCompletionHandler:(nonnull RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(nonnull SKProduct*)product;
- (BOOL)productPurchased:(nonnull NSString*)productIdentifier;
- (void)restoreCompletedTransactions;

- (void)clearPurchaseHistory;

@end
