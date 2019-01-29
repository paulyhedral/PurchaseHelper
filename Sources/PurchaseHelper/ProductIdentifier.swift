//
//  ProductIdentifier.swift
//  PurchaseHelper
//
//  Created by Paul Schifferer on 8/16/14.
//  Copyright (c) 2019 Pilgrimage Software. All rights reserved.
//

import Foundation
import StoreKit


/**
 */
public struct ProductIdentifier : Hashable {

    /**
     */
    public let id : Identifier<SKProduct>

}
   

extension ProductIdentifier : ExpressibleByStringLiteral {

    /**
     */
    public init(stringLiteral value : String) {
        self.id = Identifier<SKProduct>(stringLiteral: value)
    }

}


extension ProductIdentifier : CustomStringConvertible {

    public var description : String {
        return self.id.rawValue
    }
    
}
