//: [Previous](@previous)

import Foundation
import ReactiveSwift
import UIKit
import Workshop
import PlaygroundSupport

class NetworkController: UserviewController {
    //    public var spinner: UIActivityIndicatorView!
    //    public var getUserButton: UIButton!

    var buttons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserButton.addTarget(self, action: #selector(NetworkController.loadUser), for: .touchUpInside)
    }

    @objc func loadUser() {
        showLoading()

        ReactiveNetwork.getUser()
            .flatMap(.latest, { user in
                SignalProducer.zip(
                    ReactiveNetwork.getUserSubscriptionStatus(for: user),
                    ReactiveNetwork.getUserProfile(for: user)
                    )
                    .map({ subscription, profile in (user, subscription, profile )})
            })
            .observe(on: QueueScheduler.main)
            .startWithResult { result in
                switch result {
                case let .success((user, subscription, profile)):
                    self.allowUserToProceed(with: user, profile: profile, subscription: subscription)
                case let .failure(error):
                    print("Failure(\(error)")
                }

                self.hideLoading()
        }

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

