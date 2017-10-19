//
//  RPGPurchaseHelper.h
//  RPGKit
//
//  Created by Paul Schifferer on 9/3/14.
//  Copyright (c) 2014 Pilgrimage Software. All rights reserved.
//

@import Foundation;
@import StoreKit;


/**
 Type definition for the request products completion callback.
 
 @param success Boolean value indicating whether the request succeeded or not.
 @param products An array of SKProduct objects.
 */
typedef void (^RequestProductsCompletionHandler)(BOOL success,  NSArray<SKProduct*>* _Nonnull products);

/**
 String constant name of the notification that is sent when a product is purchased.
 */
UIKIT_EXTERN NSString* _Nonnull const ProductPurchasedNotification;
/**
 String constant name of the user info dictionary key containing the product identifier of the product that was
 purchased.
 */
UIKIT_EXTERN NSString* _Nonnull const ProductPurchasedNotificationProductIdentifierKey;

/**
 Instances of this class handle product purchasing, including tracking of previously purchased products using
 a specified keychain account.
 */
@interface PurchaseHelper : NSObject
<SKProductsRequestDelegate, SKPaymentTransactionObserver>

/**
 The keychain account that is used for storing purchase entries in the user's keychain.
 */
@property (nonatomic, nonnull, copy) NSString* keychainAccount;
/**
 Indicates whether the helper is operating in "test mode". Enabling this mode causes the helper to skip some
 checks for purchased products, allowing the app developer to test purchase functionality without having to actually
 perform purchases, even with an iTunes test account.
 */
@property (nonatomic, assign) BOOL testMode;

/**
 Instantiate this class to help manage in-app purchases.
 
 Designated initializer.
 
 @param productIdentifiers A collection of unique identifiers for the purchasable products that the app will use.
 @param keychainAccount The name of the keychain account to use for storing and managing product purchases.
 */
- (nonnull instancetype)initWithProductIdentifiers:(nonnull NSSet*)productIdentifiers
                                   keychainAccount:(nonnull NSString*)keychainAccount NS_DESIGNATED_INITIALIZER;

/**
 Initiate a request from the iTunes store for the products that correspond to the product identifiers provided
 during instantiation. The specified function will be called when the request completes.
 
 @param completionHandler A block to call when the request completes.
 
 @see RequestProductsCompletionHandler
 */
- (void)requestProductsWithCompletionHandler:(nonnull RequestProductsCompletionHandler)completionHandler;
/**
 Initiate a purchase request for the specified product.
 
 @param productIdentifier The identifier for the product to purchase. This must be an identifier that was provided
 during instantation.
 */
- (void)buyProduct:(nonnull NSString*)productIdentifier NS_SWIFT_NAME(buy(productIdentifier:));
/**
 Check if the specified product was purchased.
 
 This method uses the keychain as a record of purchased products, which is automatically updated when a purchase
 succeeds.
 
 @param productIdentifier The identifier of the product to check.
 
 @return A boolean indicating whether there is a record in the keychain for the purchase of this product.
 */
- (BOOL)productPurchased:(nonnull NSString*)productIdentifier NS_SWIFT_NAME(isProductPurchased(productIdentifier:));
/**
 Initiate a request to restore completed transactions. Each completed transaction will be recorded in the keychain.
 */
- (void)restoreCompletedTransactions;

/**
 Clears the keychain of purchase history items.
 */
- (void)clearPurchaseHistory;

@end
