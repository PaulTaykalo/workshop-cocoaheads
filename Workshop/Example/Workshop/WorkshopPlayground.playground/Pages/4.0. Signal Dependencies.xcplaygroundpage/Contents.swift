//: [Previous](@previous)

import Foundation
import ReactiveSwift
import UIKit
import Result

var dep: String = 12

let s = SignalProducer.init { o, l in
    o.send(value: dep)
    o.sendCompleted()
}

class Model {

    // Can be injected for testing
    var dependency: String = ""

    // Can be injected for testing
    var dependecySignal: SignalProducer<String, NoError> = .empty

    func doWork() -> SignalProducer<String, NoError> {
        return .init { o, l in
            o.send(value: dependency)
            o.sendCompleted()
        }
    }
}



//: [Next](@next)
