//
//  PurchasesViewController.swift
//  PurchaseHelper
//
//  Created by Paul Schifferer on 8/15/14.
//  Copyright (c) 2019 Pilgrimage Software. All rights reserved.
//

import Foundation
import StoreKit


#if os(iOS)

private func color(decimal : Int) -> CGFloat {
    return CGFloat(decimal) / 255.0
}

public class PurchasesViewController : UIViewController, UITableViewDelegate {

    @IBOutlet weak var backingView : UIView!
    @IBOutlet weak var contentContainer : UIView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var cancelButton : UIButton!
    @IBOutlet weak var restoreButton : UIButton!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var noPurchasesLabel : UILabel!

    public var showRestoreButton : Bool = false
    public var dataSource : ProductsDataSource? {
        didSet {
            self.tableView?.dataSource = dataSource
        }
    }
    public var purchaseHelper : PurchaseHelper?
    public var titleFont : UIFont?
    public var buttonFont : UIFont?
    public var emptyListFont : UIFont?

    public init() {
        let thisBundle = Bundle(for: PurchasesViewController.self)
        super.init(nibName: "PurchasesView", bundle: thisBundle)
    }

    public required init?(coder decoder : NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: color(decimal: 156),
                                            green: color(decimal: 188),
                                            blue: color(decimal: 124),
                                            alpha: 1)

        self.backingView.layer.cornerRadius = 5;
        self.backingView.layer.masksToBounds = true

        self.cancelButton.titleLabel?.font = self.buttonFont ?? UIFont.systemFont(ofSize: 17)
        self.titleLabel.font = self.titleFont ?? UIFont.systemFont(ofSize: 17)
        self.restoreButton.titleLabel?.font = self.buttonFont ?? UIFont.systemFont(ofSize: 17)
        self.restoreButton.isHidden = !self.showRestoreButton

        self.tableView.separatorColor = self.view.backgroundColor
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100

        self.tableView.isHidden = true
        self.noPurchasesLabel.isHidden = false
        self.noPurchasesLabel.text = NSLocalizedString("Loading...", comment: "")
        self.noPurchasesLabel.font = self.emptyListFont ?? UIFont.systemFont(ofSize: 32)
        self.noPurchasesLabel.textColor = .darkGray

        let thisBundle = Bundle(for: PurchasesViewController.self)
        let nib = UINib(nibName: "PurchaseItemCell", bundle: thisBundle)
        self.tableView.register(nib, forCellReuseIdentifier: "Product")

        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchase(_:)),
                                               name: ProductPurchasedNotification,
                                               object: nil)
    }

    @objc private func handlePurchase(_ note : Notification) {
        guard let userInfo = note.userInfo,
            let productId = userInfo[ProductPurchasedNotificationProductIdentifierKey] as? ProductIdentifier else { return }

        DispatchQueue.main.async {
//            for product in self.products {
//                let pId = ProductIdentifier(stringLiteral: product.productIdentifier)
//                if pId == productId,
//                    let index = self.products.index(where: { $0 == product }) {
//                    let indexPath = IndexPath(row: index, section: 0)
//                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                    return
//                }
//            }

            // new product, reload the whole table
            self.tableView.reloadData()
        }
    }

    public override func viewDidAppear(_ animated : Bool) {
        super.viewDidAppear(animated)

        self.purchaseHelper?.requestProducts(with: { success, products in
            if success, products.count > 0 {
//                self.products = products

                DispatchQueue.main.async {
                    self.noPurchasesLabel.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.tableView.isHidden = true
                    self.noPurchasesLabel.isHidden = false
                    self.noPurchasesLabel.text = NSLocalizedString("No purchases", comment: "")
                }
            }
        })
    }

    public override var prefersStatusBarHidden : Bool {
        return false
    }

    public override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }


    // MARK: - UI callbacks

    @IBAction func closeTouched(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func restoreTouched(_ sender : UIButton) {
        self.purchaseHelper?.restoreCompletedTransactions()
    }

    @IBAction func buyTouched(_ sender : UIButton) {

        sender.isEnabled = false

//        if let product = sender.representedObject as? SKProduct {
//            self.purchaseHelper.buy(product: product.productIdentifier)
//        }
    }


    // MARK: - Table view delegate methods

    public func tableView(_ tableView : UITableView, didSelectRowAt indexPath : IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let dataSource = self.dataSource else {
            NSLog("No data source provided.")
            return
        }
        guard let purchaseHelper = self.purchaseHelper else {
            NSLog("No purchase helper provided.")
            return
        }

        let product = dataSource.products[indexPath.row]
        let command = PurchaseCommand(productId: ProductIdentifier(stringLiteral: product.productIdentifier)).execute(with: purchaseHelper)
    }

}

#endif
