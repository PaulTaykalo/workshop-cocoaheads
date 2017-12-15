//: [Previous](@previous)

import Foundation
import ReactiveSwift
import UIKit
import Workshop
import PlaygroundSupport

class NetworkController: UserviewController {

    let hud = MutableProperty<Bool>(false)

    lazy var loadUserAction = Action { [unowned self] in
        return self.getUser()
            .flatMap(.latest, { user in
                SignalProducer.zip(
                    self.getUserSubscriptionStatus(for: user),
                    self.getUserProfile(for: user)
                    )
                    .map({ subscription, profile in (user, profile, subscription)})
            })
            .observe(on: QueueScheduler.main)

    }

    var buttons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()

        spinner.hidesWhenStopped = false
        buttons = [gettingUser, gettingUserProfilePic, validatingSubscriptionButton, letsGoButton]
        buttons.forEach { $0.alpha = 0}

        getUserButton.addTarget(self, action: #selector(NetworkController.loadUser), for: .touchUpInside)

        hud <~ loadUserAction.isExecuting
        // Setup bindings

        hud.signal.filter{ $0 == true }.map{ _ in ()}.observeValues(showLoading)
        hud.signal.filter{ $0 == false }.map{ _ in ()}.observeValues(hideLoading)

        loadUserAction.values.observeValues(allowUserToProceed)
        loadUserAction.errors.observeValues(showError)

    }

    func getUser() -> SignalProducer<User, ReactiveNetwork.Error> {
        let button = gettingUser!
        return ReactiveNetwork.getUser()
            .observe(on: QueueScheduler.main)
            .on(
                starting: { button.alpha = 1},
                terminated: { button.alpha = 0 }
            )
    }

    func getUserSubscriptionStatus(for user: User) -> SignalProducer<UserSubscription, ReactiveNetwork.Error> {
        let button = validatingSubscriptionButton!
        return ReactiveNetwork.getUserSubscriptionStatus(for: user)
            .observe(on: QueueScheduler.main)
            .on(
                starting: { button.alpha = 1},
                disposed: { button.alpha = 0 }
            )
    }

    func getUserProfile(for user: User) -> SignalProducer<UserProfile, ReactiveNetwork.Error> {
        let button = gettingUserProfilePic!
        return ReactiveNetwork.getUserProfile(for: user)
            .observe(on: QueueScheduler.main)
            .on(
                starting: { button.alpha = 1},
                disposed: { button.alpha = 0 }
         )
    }

    @objc func loadUser() {
        loadUserAction.apply().start()
    }

    func showError(error: ReactiveNetwork.Error) {
        print("Failure \(error)")
    }

    func allowUserToProceed(with user: User, profile: UserProfile, subscription: UserSubscription) {
        print("Yuppe, we can proceed!")
    }

    func showLoading() {
        spinner.alpha = 1
        spinner.startAnimating()
    }

    func hideLoading() {
        spinner.alpha = 0
        spinner.stopAnimating()
    }

}


PlaygroundPage.current.liveView = NetworkController()


//: [Next](@next)



