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
//    appleTree.apples().map { $0 as Fruit}
    bananaTree.bananas().map { $0 as Fruit},
    watermelonTree.watermelons().map { $0 as Fruit}
    )
    .on(value: { print("🌴" + $0.description) })


// This is how we should box our fruits right now
let delivery: ([Fruit]) -> SignalProducer<DeliveryEvent, NoError> = ponyDelivery
let tryBox: (Delivery) -> SignalProducer<Box, BoxingError> = lazyBoxer
let tryShipping: ([Box]) -> SignalProducer<Shipping, ShippingError> = ship
let tryTrade: (Shipped) -> SignalProducer<DirtyMoney, TradingError> = sneakyTrader
let cleaning: (SignalProducer<DirtyMoney, NoError>) -> SignalProducer<CleanMoney, NoError> = moneyLaundry

// Starting here
/*: Getting money
 # Task 5.1 Supply chain
 Here we need to perform supply chain with next parts
 1. Deliver frutis to the place where we can box them
 2. Perform boxing
 3. Ship boxes
 4. Trade our boxes to sneaky trader
 5. "Clean up" money using money laundry
 */

growingFruits
    .producer
    .collect(count: 2)
    .flatMap(.latest, delivery)
    .on(value: { print($0) })
    .flatMap(.merge) { (event: DeliveryEvent) -> SignalProducer<Delivery, NoError> in
        if case let .delivered(delivery) = event {
            return .init(value: delivery.1)
        }
        return .empty
    }
    .flatMap(.merge) { (delivery: Delivery) -> SignalProducer<Box, NoError> in
        tryBox(delivery).flatMapError { _ in SignalProducer<Box, NoError>.empty }
    }
    .on(value: { print("              " + $0.description) })
    .collect(count: 3)
    .flatMap(.merge) { (boxes: [Box]) -> SignalProducer<Shipping, NoError> in
        tryShipping(boxes).flatMapError { _ in SignalProducer<Shipping, NoError>.empty }
    }
    //.on(value: { print("               Shipping \($0.description)") })
    .startWithValues { value in
        print("               Shipping \(value)")
}

PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
