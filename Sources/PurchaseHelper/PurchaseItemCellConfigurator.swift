//
//  PurchaseItemCellConfigurator.swift
//  PurchaseHelper
//
//  Created by Paul Schifferer on 1/25/19.
//  Copyright © 2019 Pilgrimage Software. All rights reserved.
//

import Foundation
import StoreKit


class PurchaseItemCellConfigurator {

    private var cell : PurchaseItemCell
    private let formatter = NumberFormatter()

    init(_ cell : PurchaseItemCell) {
        self.cell = cell

        self.formatter.numberStyle = .currency
    }

    func configure(product : SKProduct, buyAction : Selector, state : PurchaseState = .purchasable,
                   productNameFont : UIFont? = nil,
                   productDescriptionFont : UIFont? = nil,
                   priceLabelFont : UIFont? = nil,
                   buyButtonFont : UIFont? = nil) {

        self.formatter.locale = product.priceLocale

        cell.backgroundColor = .clear
        cell.representedObject = product

        cell.nameLabel.text = product.localizedTitle
        cell.nameLabel.font = productNameFont ?? UIFont.systemFont(ofSize: 17)

        cell.descriptionLabel.attributedText = NSAttributedString(string: product.localizedDescription)
        cell.descriptionLabel.font = productDescriptionFont ?? UIFont.systemFont(ofSize: 15)

        cell.priceLabel.text = self.formatter.string(from: product.price)
        cell.priceLabel.font = priceLabelFont ?? UIFont.systemFont(ofSize: 24)

        if state == .purchased {
            cell.buyButton.titleLabel?.text = "👍";
        }
        else {
            cell.buyButton.titleLabel?.text = NSLocalizedString("Buy", comment: "")
            cell.buyButton.titleLabel?.font = buyButtonFont ?? UIFont.systemFont(ofSize: 24)
        }
        cell.buyButton.isEnabled = (state == .purchasable)
        cell.buyButton.removeTarget(self, action: nil, for: .allEvents)
        cell.buyButton.addTarget(self, action: buyAction, for: .touchUpOutside)

        cell.buyButton.representedObject = product
    }

    enum PurchaseState {
        case unpurchased
        case purchasable
        case purchased
    }

}
