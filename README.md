
[![Build Status](https://travis-ci.org/paulyhedral/PurchaseHelper.svg?branch=master)](https://travis-ci.org/paulyhedral/PurchaseHelper)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)
[![Cocoapods compatible](https://img.shields.io/cocoapods/v/PurchaseHelper.svg?style=flat)](https://cocoapods.org/pods/PurchaseHelper)
[![License: MIT](https://img.shields.io/cocoapods/l/PurchaseHelper.svg?style=flat)](http://opensource.org/licenses/MIT)

# PurchaseHelper

In-app purchase helper and UI elements

## Usage

### Integration

#### CocoaPods

To use PurchaseHelper with CocoaPods, add the following line to your `Podfile`:

```ruby
pod 'PurchaseHelper'
```

#### Carthage

To use PurchaseHelper with Carthage, add the following line to your `Cartfile`:

```carthage
github "paulyhedral/PurchaseHelper"
```

### Helper

Instantiate the helper once, and keep a strong reference to it somewhere.

```swift
let productIds = Set<ProductIdentifier>("product1", "product2", "product3")
let helper = PurchaseHelper(productIdentifiers: productIds,
                            keychainAccount:"MyIAPs")
```

Buy a product:

```swift
let productId = ProductIdentifier(stringLiteral: "product2")
helper.buy(productIdentifier: productId)
```

And check if a product was bought:

```swift
let productId = ProductIdentifier(stringLiteral: "product3")
if helper.isProductPurchased(productId) {
    // show some feature
}
else {
    // encourage the user to buy this feature
}
```

Restore completed transactions:

```swift
helper.restoreCompletedTransactions()
```

### UI

Create the view controller, providing it a reference to the helper. Customize its appearance, then display it.

```swift
let vc = PurchasesViewController(purchaseHelper: helper)

vc.titleFont = appTitleFont
vc.buttonFont = appButtonFont
...

self.present(vc, animated: true, completion: nil)
```

If your app needs to know when the purchase completed, setup a notification observer:

```swift
NotificationCenter.default.addObserver(self, selector: #selector(handlePurchase(_:)), name: ProductPurchasedNotification, object: nil)

...

func handlePurchase(_ note : Notification) {
    guard let userInfo = note.userInfo, let productId = userInfo[ProductPurchasedNotificationProductIdentifierKey] as? String else { return }
    
    // do something with the notification
}
```

### Test mode

Place the helper in test mode when testing the application's in-app purchase functionality.

```swift
helper.testMode = true
```

## Copyright

Copyright &copy; 2016-9 Pilgrimage Software

## License

See [LICENSE](LICENSE) for details.
