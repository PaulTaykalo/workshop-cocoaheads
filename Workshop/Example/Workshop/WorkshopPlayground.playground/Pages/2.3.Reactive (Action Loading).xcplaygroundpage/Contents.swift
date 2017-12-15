//: [Previous](@previous)

import Foundation
import ReactiveSwift
import UIKit
import Workshop
import PlaygroundSupport

class NetworkController: UserviewController {

    lazy var loadUserAction = Action { [unowned self] in
        return
        ReactiveNetwork.getUser()
            .flatMap(.latest, { user in
                SignalProducer.zip(
                    ReactiveNetwork.getUserSubscriptionStatus(for: user),
                    ReactiveNetwork.getUserProfile(for: user)
                    )
                    .map({ subscription, profile in (user, profile, subscription)})
            })
            .observe(on: QueueScheduler.main)

    }

    var buttons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserButton.addTarget(self, action: #selector(NetworkController.loadUser), for: .touchUpInside)

        // Setup bindings
        loadUserAction.isExecuting.signal
            .filter{ $0 == true }.map{ _ in ()}.observeValues(showLoading)
        loadUserAction.isExecuting.signal
            .filter{ $0 == false }.map{ _ in ()}.observeValues(hideLoading)

        loadUserAction.values.observeValues(allowUserToProceed)
        loadUserAction.errors.observeValues(showError)

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
        spinner.startAnimating()
    }

    func hideLoading() {
        spinner.stopAnimating()
    }

}


PlaygroundPage.current.liveView = NetworkController()


//: [Next](@next)


