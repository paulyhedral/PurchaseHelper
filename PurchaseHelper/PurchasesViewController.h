//
//  PurchasesViewController.h
//  RPGKit
//
//  Created by Paul Schifferer on 8/15/14.
//  Copyright (c) 2014 Pilgrimage Software. All rights reserved.
//

@import UIKit;


@interface PurchasesViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL showRestoreButton;
@property (nonatomic, copy) NSSet* productIdentifiers;
@property (nonatomic, copy) NSString* keychainAccount;

@property (strong, nonatomic) IBOutlet UIView *backingView;
@property (strong, nonatomic) IBOutlet UIView *contentContainer;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *restoreButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *noPurchasesLabel;

@property (nonatomic, strong) UIFont* titleFont;
@property (nonatomic, strong) UIFont* buttonFont;
@property (nonatomic, strong) UIFont* emptyListFont;
@property (nonatomic, strong) UIFont* productNameFont;
@property (nonatomic, strong) UIFont* productDescriptionFont;
@property (nonatomic, strong) UIFont* priceLabelFont;
@property (nonatomic, strong) UIFont* buyButtonFont;

- (IBAction)closeTouched:(id)sender;
- (IBAction)restoreTouched:(id)sender;
- (IBAction)buyTouched:(id)sender;

@end
