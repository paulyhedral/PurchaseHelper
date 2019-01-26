//
//  PurchaseItemCell.swift
//  PurchaseHelper
//
//  Created by Paul Schifferer on 8/16/14.
//  Copyright (c) 2019 Pilgrimage Software. All rights reserved.
//

#if os(iOS)

import UIKit


class PurchaseItemCell : UITableViewCell {
    /**
     Private property. Keep off.
     */
    @IBOutlet weak var nameLabel : UILabel!
    /**
     Private property. Keep off.
     */
    @IBOutlet weak var descriptionLabel : UILabel!
    /**
     Private property. Keep off.
     */
    @IBOutlet weak var priceLabel : UILabel!
    /**
     Private property. Keep off.
     */
    @IBOutlet weak var buyButton : UIButton!

}

#endif 
