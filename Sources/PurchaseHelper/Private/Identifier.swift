//
//  Identifier.swift
//  PurchaseHelper
//
//  Created by Paul Schifferer on 1/25/19.
//  Copyright © 2019 Pilgrimage Software. All rights reserved.
//

import Foundation


public struct Identifier<Value> : Hashable {

    let rawValue : String

    public init(rawValue : String) {
        self.rawValue = rawValue
    }
    
}


extension Identifier : ExpressibleByStringLiteral {

    public init(stringLiteral value : String) {
        self.rawValue = value
    }

}


extension Identifier : CustomStringConvertible {

    public var description : String {
        return rawValue
    }

}


extension Identifier : Codable {

    public init(from decoder : Decoder) throws {
        let container = try decoder.singleValueContainer()
        rawValue = try container.decode(String.self)
    }

    public func encode(to encoder : Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
}
