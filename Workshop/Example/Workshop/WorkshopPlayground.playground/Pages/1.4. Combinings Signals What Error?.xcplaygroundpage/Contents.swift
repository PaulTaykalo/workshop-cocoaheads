//: [Previous](@previous)

import Foundation
import ReactiveSwift
import Workshop
import PlaygroundSupport
import Result

let appleTree = Jungles.appleTree()
let bananaTree = Jungles.bananaTree()
let watermelonTree = Jungles.watermelonTree()

// Other trees? :) 🍋 :

// Now we need to ship our staff to other countries!
let growingFruits = Signal<Fruit, NoError>.merge(
        appleTree.apples().map { $0 as Fruit},
        bananaTree.bananas().map { $0 as Fruit},
        watermelonTree.watermelons().map { $0 as Fruit}
    )
    .on(value: { print("Grown \($0)")})

let packager =
    growingFruits
        .producer
        .collect(count: 2)
        .flatMap(.merge, box)
        .on(value: { print("Packed \($0)")})


/*:
  Let's ship our boxes by 3 at a time
 We have `shipping` function which will ship arrays of boxes and receive money
 Shipping is unsage operation, so it can fail from time to time
 ```
// public func ship(boxes: [Box]) -> SignalProducer<Shipping, ShippingError>
 ```
 run playground and see the results
 */

let shipping = packager
    .collect(count: 3)
    .flatMap(.merge) { boxes -> SignalProducer<Shipping, ShippingError> in ship(boxes: boxes) }


shipping.startWithResult { result in
    switch result {
    case .success(let ship):
        print("Shipping \(ship)")
    case .failure(let error):
        print("\(error)")
    }
}

/*: FIXME
 ## Task 4.1 Problems with shipping???
 Given `shipping` signal and `safeTradeRoute` function
 ```
public func safeTradeRoute(safeShipment: SignalProducer<Shipping, NoError>) -> SignalProducer<Money,NoError>
 ```
 Setup trading route using `shipping` signal

 - 
*/
//let money = safeTradeRoute(safeShipment: shipping)
//    .startWithValues { money in
//        print(money)
//}


PlaygroundPage.current.needsIndefiniteExecution = true
//: [Next](@next)
