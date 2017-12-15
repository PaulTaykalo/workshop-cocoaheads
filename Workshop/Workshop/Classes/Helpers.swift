import Foundation
import ReactiveSwift
import Result

public protocol Fruit: CustomStringConvertible {
    var name: String { get }
}

public extension Fruit {
    public var description: String {
        return name
    }
}
public struct Apple: Fruit {
    public var name: String { return "🍎" }
}
public struct Banana: Fruit {
    public var name: String { return "🍌" }
}

public struct WaterMelon: Fruit {
    public var name: String { return "🍉" }
}

public struct Box: CustomStringConvertible {
    public let fruits: [Fruit]

    public var description: String {
        return "📦(" + fruits.map{ $0.name}.joined(separator: ",") + ")"
    }

    public init(fruits: [Fruit]) {
        self.fruits = fruits
    }
}


public enum Shipping {
    case started
    case shipped(Shipped)
}

public struct Shipped: CustomStringConvertible {
    let boxes: [Box]

    public var description: String {
        return "🚢<" + boxes.map { $0.description}.joined(separator: "," ) + ">"
    }

}

public class AppleTree {

    var s = Signal<Apple,NoError>.pipe()

    init() {
        var block: () -> () = {}
        block = { DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
            self.s.input.send(value: Apple())
            block() }
        )}
        block()
    }

    public func apples() -> Signal<Apple,NoError> { return s.output }
}

public class BananaTree {

    var s = Signal<Banana,NoError>.pipe()

    init() {
        var block: () -> () = {}
        block = { DispatchQueue.global().asyncAfter(deadline: .now() + 1.5, execute: {
            self.s.input.send(value: Banana())
            block() }
            )}
        block()
    }

    public func bananas() -> Signal<Banana,NoError> { return s.output }
}

public class WaterMelonTree {

    var s = Signal<WaterMelon,NoError>.pipe()

    init() {
        var block: () -> () = {}
        block = { DispatchQueue.global().asyncAfter(deadline: .now() + 5, execute: {
            self.s.input.send(value: WaterMelon())
            block() }
            )}
        block()
    }

    public func watermelons() -> Signal<WaterMelon,NoError> { return s.output }
}

public struct Jungles {
    private static let s = Signal<Apple,NoError>.pipe()
    public static func appleTree() -> AppleTree {
        return AppleTree()
    }
    public static func bananaTree() -> BananaTree {
        return BananaTree()
    }
    public static func watermelonTree() -> WaterMelonTree {
        return WaterMelonTree()
    }
}

// MARK: Signal Producers

public func box(fruits:[Fruit]) -> SignalProducer<Box, NoError> {
    return .init { o, l in
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            o.send(value: Box(fruits: fruits))
            o.sendCompleted()
        }
    }
}


// Mark: Shipping
public enum ShippingError: Swift.Error, CustomStringConvertible {
    case drown

    public var description: String {
        switch self {
        case .drown:
            return "Drown 🌊🐙🚢🌊"
        }
    }
}
public func ship(boxes: [Box]) -> SignalProducer<Shipping, ShippingError> {
    return .init { o, l in
        o.send(value: .started)
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            if arc4random() % 5 == 1 {
                o.send(error: .drown)
            } else {
                o.send(value: .shipped(Shipped(boxes: boxes)))
                o.sendCompleted()
            }
        }
    }
}


// MARK: Trade route

public struct Money: CustomStringConvertible {
    let value: String

    public var description: String {
        return value
    }
}
public func safeTradeRoute(safeShipment: SignalProducer<Shipping, NoError>) -> SignalProducer<Money,NoError> {
    return safeShipment
        .map { shipping -> Shipped? in
            switch shipping {
            case .shipped(let shipped): return shipped
            case .started: return nil
            }
        }
        .skipNil()
        .flatMap(.latest) { shipped -> SignalProducer<Money, NoError> in
        return SignalProducer.init(shipped.boxes
            .flatMap { box in
                box.fruits
            }
            .map { fruit in "💰"}
            .flatMap { Money(value: $0)}
        )
    }
}
