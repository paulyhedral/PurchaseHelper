//
//  PurchaseHelper.m
//  RPGKit
//
//  Created by Paul Schifferer on 9/3/14.
//  Copyright (c) 2014 Pilgrimage Software. All rights reserved.
//

#import "PurchaseHelper.h"

#import <SAMKeychain/SAMKeychain.h>


NSString* const ProductPurchasedNotification = @"ProductPurchased";
NSString* const ProductPurchasedNotificationProductIdentifierKey = @"product";

@implementation PurchaseHelper {

@private
    SKProductsRequest* _productsRequest;
    RequestProductsCompletionHandler _completionHandler;

    NSSet<NSString*>* _productIdentifiers;
    NSMutableSet<NSString*>* _purchasedProductIdentifiers;
    NSMutableDictionary<NSString*, SKProduct*>* _products;

    //    NSMutableDictionary* _requestMap;
    //    NSMutableDictionary* _handlerMap;
    NSDictionary* _productEquivalenceMap;

}

- (instancetype)init {
    [NSException raise:@"MethodUnimplementedException"
                format:@"Method not implemented: %@", NSStringFromSelector(_cmd)];
    return [self initWithProductIdentifiers:[NSSet set]
                            keychainAccount:@""];
}

- (instancetype)initWithProductIdentifiers:(NSSet*)productIdentifiers
                           keychainAccount:(NSString*)keychainAccount {
    self = [super init];
    if(self) {
        _productIdentifiers = productIdentifiers;
        _keychainAccount = keychainAccount;
        _products = [NSMutableDictionary new];
        //        _requestMap = [NSMutableDictionary new];
        //        _handlerMap = [NSMutableDictionary new];

        [SAMKeychain setAccessibilityType:kSecAttrAccessibleAlways];

        // check for previously purchased items
        _purchasedProductIdentifiers = [NSMutableSet new];
        NSArray* purchases = [SAMKeychain accountsForService:_keychainAccount];
        for(NSDictionary* purchaseDict in purchases) {
            NSString* productId = purchaseDict[(__bridge id)kSecAttrAccount];

            NSLog(@"Previously purchased: %@", productId);
            [_purchasedProductIdentifiers addObject:productId];
        }

        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }

    return self;
}


#pragma mark - Worker methods

- (void)completeTransaction:(SKPaymentTransaction*)transaction {

    NSLog(@"Completing transaction %@...", transaction);

    [self provideContentForTransaction:transaction
                     productIdentifier:transaction.payment.productIdentifier];

    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)handleFailedTransaction:(SKPaymentTransaction*)transaction {

    NSLog(@"Handling failed transaction %@...", transaction);

    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"Transaction error: %@", transaction.error);
    }

    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction*)transaction {

    NSLog(@"Restoring transaction %@...", transaction);

    [self provideContentForTransaction:transaction
                     productIdentifier:transaction.payment.productIdentifier];

    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)provideContentForTransaction:(SKPaymentTransaction*)transaction
                   productIdentifier:(NSString*)productId {

    [_purchasedProductIdentifiers addObject:productId];

    [SAMKeychain setPassword:transaction.transactionIdentifier
                  forService:_keychainAccount
                     account:productId];

    [[NSNotificationCenter defaultCenter] postNotificationName:ProductPurchasedNotification
                                                        object:self
                                                      userInfo:(@{
                                                                  ProductPurchasedNotificationProductIdentifierKey : productId,
                                                                  })];
}

- (NSArray*)productIdentifiers {
    return [_productIdentifiers allObjects];
}


#pragma mark - Public API

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {

    if(_productsRequest) {
        NSLog(@"Product request is already in progress!");
        return;
    }

    NSLog(@"Starting products request...");

    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _completionHandler = completionHandler;

    //    NSString* requestKey = [NSString stringWithFormat:@"%p", _productsRequest];
    //    _requestMap[requestKey] = _productsRequest;
    //    _handlerMap[requestKey] = [completionHandler copy];

    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (void)buyProduct:(nonnull NSString*)productIdentifier {

    NSLog(@"Buying %@...", productIdentifier);

    SKProduct* product = _products[productIdentifier];
    SKPayment* payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (BOOL)productPurchased:(NSString*)productIdentifier {

    if(_testMode) {
        return YES;
    }

    // check for item on keychain
    NSString* transactionId = [SAMKeychain passwordForService:_keychainAccount
                                                      account:productIdentifier];
    if(transactionId == nil) {
        NSArray* equivalents = _productEquivalenceMap[productIdentifier];
        for(NSString* equivalentId in equivalents) {
            transactionId = [SAMKeychain passwordForService:_keychainAccount
                                                    account:equivalentId];
            if(transactionId) {
                productIdentifier = equivalentId;
                break;
            }
        }
    }

    return (transactionId != nil &&
            [_purchasedProductIdentifiers containsObject:productIdentifier]);
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)clearPurchaseHistory {
#ifdef DEBUG
    for(NSString* productId in [self productIdentifiers]) {
        [SAMKeychain deletePasswordForService:_keychainAccount
                                      account:productId];
        [_purchasedProductIdentifiers removeObject:productId];
    }
#endif
}


#pragma mark - Store Kit delegate methods

- (void)productsRequest:(SKProductsRequest*)request
     didReceiveResponse:(SKProductsResponse*)response {

    //    NSString* requestKey = [NSString stringWithFormat:@"%p", request];
    //    RequestProductsCompletionHandler completionHandler = _handlerMap[requestKey];
    //
    //    [_requestMap removeObjectForKey:requestKey];
    //    [_handlerMap removeObjectForKey:requestKey];

    NSLog(@"Loaded list of products...");

    NSArray* products = response.products;
    for(SKProduct* product in products) {
        _products[product.productIdentifier] = product;
        NSLog(@"Found product: %@ %@ %0.2f", product.productIdentifier, product.localizedTitle, product.price.floatValue);
    }

    _completionHandler(YES, products);
}

- (void)request:(SKRequest*)request
didFailWithError:(NSError*)error {

    //    NSString* requestKey = [NSString stringWithFormat:@"%p", request];
    //
    //    RequestProductsCompletionHandler completionHandler = _handlerMap[requestKey];
    //
    //    [_requestMap removeObjectForKey:requestKey];
    //    [_handlerMap removeObjectForKey:requestKey];
    _productsRequest = nil;

    _completionHandler(NO, @[]);

}

- (void)paymentQueue:(SKPaymentQueue*)queue
restoreCompletedTransactionsFailedWithError:(NSError*)error {

    NSLog(@"Restore transactions failed: %@", error);

    // TODO?
}

- (void)paymentQueue:(SKPaymentQueue*)queue
 updatedTransactions:(NSArray*)transactions {

    for(SKPaymentTransaction* tx in transactions) {
        switch(tx.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:tx];
                break;

            case SKPaymentTransactionStateFailed:
                [self handleFailedTransaction:tx];
                break;

            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:tx];
                break;
                
            default:
                // do nothing
                break;
        }
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue*)queue {
    
}

@end
