//
//  PurchaseCommand.swift
//  PurchaseHelper
//
//  Created by Paul Schifferer on 1/26/19.
//  Copyright © 2019 Pilgrimage Software. All rights reserved.
//

import Foundation


/**
 */
public class PurchaseCommand {

    private var productId : ProductIdentifier

    /**
     */
    public init(productId : ProductIdentifier) {
        self.productId = productId
    }

    /**
     */
    public func execute(with purchaseHelper : PurchaseHelper) {
        purchaseHelper.buy(productIdentifier: self.productId)
    }

}
