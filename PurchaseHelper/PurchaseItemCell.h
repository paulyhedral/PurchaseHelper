//
//  PurchaseItemCell.h
//  RPGKit
//
//  Created by Paul Schifferer on 8/16/14.
//  Copyright (c) 2014 Pilgrimage Software. All rights reserved.
//

@import UIKit;


@interface PurchaseItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;

@end
