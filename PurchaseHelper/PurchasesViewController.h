//
//  PurchasesViewController.h
//  RPGKit
//
//  Created by Paul Schifferer on 8/15/14.
//  Copyright (c) 2014 Pilgrimage Software. All rights reserved.
//

@import UIKit;
#import "PurchaseHelper.h"


/**
 A UIViewController subclass that manages the purchasable items user interface.
 */
@interface PurchasesViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

/**
 Indicates whether the "Restore" button should be shown on the UI.
 */
@property (nonatomic, assign) BOOL showRestoreButton;
/**
 An instance of the PurchaseHelper, used for properly reflecting the purchase status of displayed items.
 */
@property (nonatomic, nonnull, strong) PurchaseHelper* purchaseHelper;

/**
 Private property. Keep off.
 */
@property (strong, nonnull, nonatomic) IBOutlet UIView *backingView;
/**
 Private property. Keep off.
 */
@property (strong, nonnull, nonatomic) IBOutlet UIView *contentContainer;
/**
 The label used for the view's title. Clients can modify the attributes of this label.
 */
@property (strong, nonnull, nonatomic) IBOutlet UILabel *titleLabel;
/**
 The view's cancel button. Clients can modify the attributes of this button.
 */
@property (strong, nonnull, nonatomic) IBOutlet UIButton *cancelButton;
/**
 The view's restore button. Clients can modify the attributes of this button.
 */
@property (strong, nonnull, nonatomic) IBOutlet UIButton *restoreButton;
/**
 Private property. Keep off.
 */
@property (strong, nonnull, nonatomic) IBOutlet UITableView *tableView;
/**
 The label that is shown if no purchases are found to display in the view. Clients can modify
 the attributes of this label.
 */
@property (strong, nonnull, nonatomic) IBOutlet UILabel *noPurchasesLabel;

/**
 An optional property specifying the font to use for the view's title. Clients should set this so that
 the view better fits the look and feel of the application.
 */
@property (nonatomic, nullable, strong) UIFont* titleFont;
/**
 An optional property specifying the font to use for the view's buttons. Clients should set this so that
 the view better fits the look and feel of the application.
 */
@property (nonatomic, nullable, strong) UIFont* buttonFont;
/**
 An optional property specifying the font to use for the view's "empty list" text. Clients should
 set this so that the view better fits the look and feel of the application.
 */
@property (nonatomic, nullable, strong) UIFont* emptyListFont;
/**
 An optional property specifying the font to use for the purchasable items' product name. Clients
 should set this so that the view better fits the look and feel of the application.
 */
@property (nonatomic, nullable, strong) UIFont* productNameFont;
/**
 An optional property specifying the font to use for the purchasable items' description text. Clients
 should set this so that the view better fits the look and feel of the application.
 */
@property (nonatomic, nullable, strong) UIFont* productDescriptionFont;
/**
 An optional property specifying the font to use for the purchasable items' price labels. Clients
 should set this so that the view better fits the look and feel of the application.
 */
@property (nonatomic, nullable, strong) UIFont* priceLabelFont;
/**
 An optional property specifying the font to use for the purchasable items' "Buy" buttons. Clients
 should set this so that the view better fits the look and feel of the application.
 */
@property (nonatomic, nullable, strong) UIFont* buyButtonFont;

/**
 Private function.
 */
- (IBAction)closeTouched:(nonnull id)sender;
/**
 Private function.
 */
- (IBAction)restoreTouched:(nonnull id)sender;
/**
 Private function.
 */
- (IBAction)buyTouched:(nonnull id)sender;

@end
