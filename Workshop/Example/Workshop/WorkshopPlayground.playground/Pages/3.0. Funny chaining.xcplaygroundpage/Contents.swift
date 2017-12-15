//: [Previous](@previous)

import Foundation
import ReactiveSwift
import UIKit
import Result

enum ApiError {
    case general
    case tokenInvalidated
}

protocol NetworkApi {
    func getUser() -> SignalProducer<User, ApiError>
}

struct Api: NetworkApi {
    func getUser() -> SignalProducer<User, ApiError> {
        return .empty
    }
}

extension SignalProducer {
    func withConfirmation(confirmation: SignalProducer<Bool, NoError>) -> SignalProducer<Value, Error> {
        return confirmation.filter({$0 == true})
            .flatMap(.latest) { _ in return self }
    }
}

//: [Next](@next)
