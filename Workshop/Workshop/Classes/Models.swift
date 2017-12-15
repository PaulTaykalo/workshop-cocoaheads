import Foundation
import ReactiveSwift
import Result


public struct User {}
public struct UserProfile {}
public struct UserSubscription {}

public struct Network {

    public static func getUser(success:@escaping (User) -> (), failure: @escaping (NSError) ->()) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            success(User())
        }
    }

    public static func getUserProfile(for: User, success:@escaping (UserProfile) -> (), failure: @escaping (NSError) ->()) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            success(UserProfile())
        }
    }

    public static func getUserSubscriptionStatus(for: User, success:@escaping (UserSubscription) -> (), failure: @escaping (NSError) ->()) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            success(UserSubscription())
        }
    }

}

public struct ReactiveNetwork {

    public enum Error: Swift.Error {
        case error(NSError)
    }
    public static func getUser() -> SignalProducer<User, Error> {
        return reactive(call: Network.getUser)
    }
    public static func getUserProfile(for user: User) -> SignalProducer<UserProfile, Error> {
        return reactive(param: user, call: Network.getUserProfile)
    }
    public static func getUserSubscriptionStatus(for user: User) -> SignalProducer<UserSubscription, Error> {
        return reactive(param: user, call: Network.getUserSubscriptionStatus)
    }

    public static func reactive<T>(call:@escaping (@escaping(T) -> (), @escaping (NSError) -> ()) -> ()) -> SignalProducer<T, Error> {
        return SignalProducer.init { o, l in
            call(
                { o.send(value: $0); o.sendCompleted()},
                { o.send(error: .error($0))
            })
        }
    }

    public static func reactive<T,P>(param: P, call:@escaping (P, @escaping(T) -> (), @escaping (NSError) -> ()) -> ()) -> SignalProducer<T, Error> {
        return SignalProducer.init { o, l in
            call(param,
                { o.send(value: $0); o.sendCompleted()},
                { o.send(error: .error($0))
            })
        }
    }


}

