//
//  PurchaseHelper.h
//  PurchaseHelper
//
//  Created by Paul Schifferer on 10/31/15.
//  Copyright © 2015 Pilgrimage Software. All rights reserved.
//

@import Foundation;
#if TARGET_OS_IPHONE
@import UIKit;
#else
@import Cocoa;
#endif

//! Project version number for PurchaseHelper.
FOUNDATION_EXPORT double PurchaseHelperVersionNumber;

//! Project version string for PurchaseHelper.
FOUNDATION_EXPORT const unsigned char PurchaseHelperVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <PurchaseHelper/PublicHeader.h>

#import <PurchaseHelper/PurchaseHelper.h>
#import <PurchaseHelper/PurchaseItemCell.h>
#import <PurchaseHelper/PurchasesViewController.h>
