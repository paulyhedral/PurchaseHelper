//
//  PurchaseItemCell.h
//  RPGKit
//
//  Created by Paul Schifferer on 8/16/14.
//  Copyright (c) 2014 Pilgrimage Software. All rights reserved.
//

@import Foundation;
#if TARGET_OS_IPHONE

@import UIKit;

/**
 Table cell instances for purchasable items.

 Not meant to be used by client code.
 */
@interface PurchaseItemCell : UITableViewCell

/**
 Private property. Keep off.
 */
@property(strong, nonnull, nonatomic) IBOutlet UILabel *nameLabel;
/**
 Private property. Keep off.
 */
@property(strong, nullable, nonatomic) IBOutlet UILabel *descriptionLabel;
/**
 Private property. Keep off.
 */
@property(strong, nonnull, nonatomic) IBOutlet UILabel *priceLabel;
/**
 Private property. Keep off.
 */
@property(strong, nonnull, nonatomic) IBOutlet UIButton *buyButton;

@end

#endif
