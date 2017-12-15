//: [Previous](@previous)

import Foundation
import ReactiveSwift
import Workshop
import PlaygroundSupport
import Result

let appleTree = Jungles.appleTree()
let bananaTree = Jungles.bananaTree()

/*: INFO:
 # Info
 - merge - will take two signals and retur signal that will merge values from source signals

 # Task 3.1
 ## Combining values of the signals

 Just run the Playground.
 Playground will fail. Why?

 - What type merged signal will have?
 - How can we fix it?
 */

let applesSignal: Signal<Apple, NoError> = appleTree.apples()
let bananasSignal: Signal<Banana, NoError> = bananaTree.bananas()

Signal.merge(
        applesSignal, bananasSignal
    )
    .map { fruit in Box(fruits: [ fruit ]) }
    .observeValues { item in
        print(item)
    }

/*: INFO:
 # Info
 - flatMap - takes function (T) -> SignalProducer<V, Error>, for every value passed in it will create
 a producer, and start it. All values of the result signals are merged using flatten strategy

 # Task 3.2
 Use box function to return signal that will return boxed fruits

 - Why when we returning SignalProducer in flatMap, we're ending up with the signal?

 */


// public func box(fruits:[Fruit]) -> SignalProducer<Box, NoError>

Signal.zip(
        applesSignal, bananasSignal
    )
//    .flatMap(.merge) { apple, banana ->   }
    .observeValues { box in
        print(box)
    }

PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
