//: [Previous](@previous)

import Foundation
import ReactiveSwift
import Workshop
import PlaygroundSupport

let appleTree = Jungles.appleTree()
let bananaTree = Jungles.bananaTree()

/*: INFO:
 # Info
 - zip - will take two signals and send values in pairs from source signals
 - map - Will transform values of the source signal to values of another type
 - on - Will print value and propagates events from the source signal


 # Task #2
 ## Combining values of the signals

 Just run the Playground
 Uncomment ons and see how values are propagated in event chain
*/

appleTree.apples().
Signal.zip(
    appleTree.apples()
//        .on(value: { val in print("Apple \(val.name)")})
    , bananaTree.bananas()
//        .on(value: { val in print("Banana \(val.name)")})
    )
//    .map { apple, banana in Box(fruits:[apple, banana]) }
    .observeValues { item in
        print(item)
    }

PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
