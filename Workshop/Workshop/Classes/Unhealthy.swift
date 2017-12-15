import Foundation
import ReactiveSwift
import Result

public struct Delivery: CustomStringConvertible {
    let fruits: [Fruit]

    public var description: String {
        return "[" + fruits.map { $0.description }.joined(separator: ",") + "]"
    }
}


public enum DeliveryEvent: CustomStringConvertible {
    public typealias PonyDescription = String

    case jumping(PonyDescription)
    case rowing(PonyDescription)
    case gallopping(PonyDescription)
    case delivered(PonyDescription, Delivery)
    public var description: String {
        switch self {
        case .jumping(let pony):
            return pony + "  ⛰⛰⛰"
        case .rowing(let pony):
            return "⛰ " + pony + " ⛰⛰"
        case .gallopping(let pony):
            return "⛰⛰ " + pony + " ⛰"
        case .delivered(let pony, _):
            return "⛰⛰⛰  " + pony  
        }
    }
}

public func ponyDelivery(fruits:[Fruit]) -> SignalProducer<DeliveryEvent, NoError> {
    return .init { o, l in
        let r = arc4random() % 3
        let pony = r == 0 ? "🦄 "
            : r == 1 ? "🐴"
            : "🏇"
        let delivey = Delivery(fruits: fruits)
        let descr = pony + delivey.description
        o.send(value:.jumping(descr))
        DispatchQueue.global().asyncAfter(deadline: .now() + Double((arc4random() % 2)) / 6.0) {
            o.send(value:.rowing(descr))
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2 + Double((arc4random() % 3)) / 6.0) {
            o.send(value:.gallopping(descr))
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            o.send(value:.delivered(descr, delivey))
            o.sendCompleted()
        }
    }
}

public enum BoxingError: Error {
    case oops
}
public func lazyBoxer(delivery: Delivery) -> SignalProducer<Box,BoxingError> {
    return .init { o, l in
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            if arc4random() % 5 == 1 {
                o.send(error: .oops)
            } else {
                o.send(value: Box(fruits: delivery.fruits))
                o.sendCompleted()
            }
        }
    }
}


public struct DirtyMoney: CustomStringConvertible {
    let money: Money

    public var description: String {
        return "❗" + money.description + "❗"

    }
}
public enum TradingError: Error {
    case whatMoney
}

// Haha... while it looks like a sneaky one, this is actually very trustful one
// But since we don't trust anyone, we need to check for trading errors
public func sneakyTrader(items: Shipped) -> SignalProducer<DirtyMoney, TradingError> {
    return SignalProducer.init(items.boxes
        .flatMap { box in
            box.fruits
        }
        .map { fruit in "💰"}
        .flatMap { Money(value: $0)}
        .map { DirtyMoney(money: $0) }
    )
}


public struct CleanMoney: CustomStringConvertible {
    public var description: String {
        return "💵"
    }
}

public func moneyLaundry(dirtyMoneySource: SignalProducer<DirtyMoney, NoError>) -> SignalProducer<CleanMoney, NoError> {
    return dirtyMoneySource.collect(count: 2).map { $0.first!}.map { _ in CleanMoney()}
}
