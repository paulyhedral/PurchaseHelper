//
//  PurchaseItemCell.h
//  RPGKit
//
//  Created by Paul Schifferer on 8/16/14.
//  Copyright (c) 2014 Pilgrimage Software. All rights reserved.
//

@import UIKit;


@interface PurchaseItemCell : UITableViewCell

@property (strong, nonnull, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nullable, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonnull, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonnull, nonatomic) IBOutlet UIButton *buyButton;

@end
