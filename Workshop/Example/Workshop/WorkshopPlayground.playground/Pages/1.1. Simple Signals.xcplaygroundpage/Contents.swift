//: [Previous](@previous)

import Foundation
import ReactiveSwift
import Workshop
import PlaygroundSupport

/*: Task description
 TASK: #1
 Run this playground and meditate by looking at values being sent
 By signals
*/

let appleTree = Jungles.appleTree()
let bananaTree = Jungles.bananaTree()

appleTree.apples().observeValues { apple in
    print(apple)
}
bananaTree.bananas().observeValues { banana in
    print(banana)
}

PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)

