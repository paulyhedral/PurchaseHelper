//
//  ProductsDataSource.swift
//  PurchaseHelper
//
//  Created by Paul Schifferer on 1/26/19.
//  Copyright © 2019 Pilgrimage Software. All rights reserved.
//

import UIKit
import StoreKit


/**
 */
public class ProductsDataSource : NSObject, UITableViewDataSource {

    public private(set) var products : [SKProduct]
    public let purchaseHelper : PurchaseHelper
    public let config : PurchaseItemCellConfiguration

    /**
     */
    public init(products : [SKProduct], purchaseHelper : PurchaseHelper, configuration : PurchaseItemCellConfiguration) {
        self.products = products
        self.purchaseHelper = purchaseHelper
        self.config = configuration

        super.init()
        
        load()
    }

    private func load() {
        self.purchaseHelper.requestProducts { success, products in
            guard success else { return }

            self.products.removeAll()
            self.products.append(contentsOf: products)
        }
    }


    // MARK: - Table view data source methods

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath) as! PurchaseItemCell

        let product = self.products[indexPath.row]
        PurchaseItemCellConfigurator(cell).configure(product: product,
//                                                     buyAction: #selector(PurchasesViewController.buyTouched(_:)),
                                                     state: self.purchaseHelper.isProductPurchased(productIdentifier: ProductIdentifier(stringLiteral: product.productIdentifier)) ? .purchased : .purchasable,
                                                     configuration: self.config)
//                                                     productNameFont: self.productNameFont,
//                                                     productDescriptionFont: self.productDescriptionFont,
//                                                     priceLabelFont: self.priceLabelFont,
//                                                     buyButtonFont: self.buyButtonFont)

        return cell
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
