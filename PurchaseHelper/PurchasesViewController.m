//
//  PurchasesViewController.m
//  RPGKit
//
//  Created by Paul Schifferer on 8/15/14.
//  Copyright (c) 2014 Pilgrimage Software. All rights reserved.
//

#import "PurchasesViewController.h"

#import "UIControl+RepresentedObject.h"

#import "PurchaseItemCell.h"

#import "PurchaseHelper.h"


#define COLOR_DECIMAL_TO_FLOAT(x) ((x) / 255.0f)

@implementation PurchasesViewController {

@private
    NSArray* _products;
    NSNumberFormatter* _formatter;
    PurchaseHelper* _helper;

}

- (instancetype)init {
    NSBundle* thisBundle = [NSBundle bundleForClass:[self class]];
    self = [super initWithNibName:@"PurchasesView"
                           bundle:thisBundle];
    if(self) {

    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:COLOR_DECIMAL_TO_FLOAT(156)
                                                green:COLOR_DECIMAL_TO_FLOAT(188)
                                                 blue:COLOR_DECIMAL_TO_FLOAT(124)
                                                alpha:1];

    _backingView.layer.cornerRadius = 5;
    _backingView.layer.masksToBounds = YES;

    _cancelButton.titleLabel.font = _buttonFont ?: [UIFont systemFontOfSize:17];
    _titleLabel.font = _titleFont ?: [UIFont systemFontOfSize:17];
    _restoreButton.titleLabel.font = _buttonFont ?: [UIFont systemFontOfSize:17];
    _restoreButton.hidden = !_showRestoreButton;

    _tableView.separatorColor = self.view.backgroundColor;

    _formatter = [NSNumberFormatter new];
    _formatter.numberStyle = NSNumberFormatterCurrencyStyle;

    _tableView.hidden = YES;
    _noPurchasesLabel.hidden = NO;
    _noPurchasesLabel.text = NSLocalizedString(@"Loading...", nil);
    _noPurchasesLabel.font = _emptyListFont ?: [UIFont systemFontOfSize:32];
    _noPurchasesLabel.textColor = [UIColor darkGrayColor];

    {
        NSBundle* thisBundle = [NSBundle bundleForClass:[self class]];
        UINib* nib = [UINib nibWithNibName:@"PurchaseItemCell"
                                    bundle:thisBundle];
        [_tableView registerNib:nib
         forCellReuseIdentifier:@"Product"];
    }

    _helper = [[PurchaseHelper alloc] initWithProductIdentifiers:_productIdentifiers
                                                 keychainAccount:_keychainAccount];

    [[NSNotificationCenter defaultCenter] addObserverForName:ProductPurchasedNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSString* productId = note.userInfo[ProductPurchasedNotificationProductIdentifierKey];

                                                      for(SKProduct* product in _products) {
                                                          NSString* pId = product.productIdentifier;
                                                          if([pId isEqualToString:productId]) {
                                                              NSUInteger index = [_products indexOfObject:product];
                                                              NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index
                                                                                                          inSection:0];
                                                              [_tableView reloadRowsAtIndexPaths:@[indexPath]
                                                                                withRowAnimation:UITableViewRowAnimationAutomatic];
                                                              return;
                                                          }
                                                      }

                                                      // new product, reload the whole table
                                                      [_tableView reloadData];
                                                  }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [_helper requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if(success &&
           [products count] > 0) {

            _products = [products copy];

            dispatch_async(dispatch_get_main_queue(), ^{
                _noPurchasesLabel.hidden = YES;
                _tableView.hidden = NO;
                [_tableView reloadData];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _tableView.hidden = YES;
                _noPurchasesLabel.hidden = NO;
                _noPurchasesLabel.text = NSLocalizedString(@"No purchases", nil);
            });
        }
    }];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - UI callbacks

- (IBAction)closeTouched:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
}

- (IBAction)restoreTouched:(id)sender {
    [_helper restoreCompletedTransactions];
}

- (IBAction)buyTouched:(UIButton*)sender {

    sender.enabled = NO;
    SKProduct* product = sender.representedObject;

    if(product) {
        [_helper buyProduct:product];
    }
}


#pragma mark - Table view data source and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [_products count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"Product"];
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

//- (CGFloat)tableView:(UITableView *)tableView
//heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    SKProduct* product = _products[indexPath.row];
//
//    NSAttributedString* desc = [[NSAttributedString alloc] initWithString:product.localizedDescription];
//    CGFloat width = tableView.bounds.size.width - 150;
//    CGRect bounds = [desc boundingRectWithSize:CGSizeMake(width, FLT_MAX)
//                                       options:NSStringDrawingUsesLineFragmentOrigin
//                                       context:nil];
//
//    return 50.0f + bounds.size.height;
//}

- (void)tableView:(UITableView*)tableView
  willDisplayCell:(UITableViewCell*)cell
forRowAtIndexPath:(NSIndexPath*)indexPath {

    SKProduct* product = _products[indexPath.row];

    cell.backgroundColor = [UIColor clearColor];
    cell.representedObject = product;

    PurchaseItemCell* productCell = (PurchaseItemCell*)cell;

    productCell.nameLabel.text = product.localizedTitle;
    productCell.nameLabel.font = _productNameFont ?: [UIFont systemFontOfSize:17];

    productCell.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:product.localizedDescription];
    productCell.descriptionLabel.font = _productDescriptionFont ?: [UIFont systemFontOfSize:15];

    productCell.priceLabel.text = [_formatter stringFromNumber:product.price];
    productCell.priceLabel.font = _priceLabelFont ?: [UIFont systemFontOfSize:24];

    if([_helper productPurchased:product.productIdentifier]) {
        productCell.buyButton.titleLabel.text = @"👍";
    }
    else {
        productCell.buyButton.titleLabel.text = NSLocalizedString(@"Buy", nil);
        productCell.buyButton.titleLabel.font = _buyButtonFont ?: [UIFont systemFontOfSize:24];
    }
    productCell.buyButton.enabled = ![_helper productPurchased:product.productIdentifier];
    [productCell.buyButton removeTarget:self
                                 action:@selector(buyTouched:)
                       forControlEvents:UIControlEventAllEvents];
    [productCell.buyButton addTarget:self
                              action:@selector(buyTouched:)
                    forControlEvents:UIControlEventTouchUpInside];
    
    productCell.buyButton.representedObject = product;
}

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    // handle the button press instead
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

@end
