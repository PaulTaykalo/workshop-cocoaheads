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
        buttons = [getUserButton, gettingUser, gettingUserProfilePic, validatingSubscriptionButton, letsGoButton]
        getUserButton.addTarget(self, action: #selector(NetworkController.loadUser), for: .touchUpInside)
    }

    @objc func loadUser() {
        showLoading()
        Network.getUser(success: { (user) in
            print("Success!")
            Network.getUserSubscriptionStatus(for: user, success: { subscription in
                Network.getUserProfile(for: user, success: { profile in

                    self.allowUserToProceed(with: user, profile: profile, subscription: subscription)
                }, failure: { (error) in
                    print("Failure \(error)")
                    DispatchQueue.main.async { self.hideLoading() }
                })
            }, failure: { (error) in
                print("Failure \(error)")
                DispatchQueue.main.async { self.hideLoading() }
            })
        }, failure: { (error) in
            print("Failure \(error)")
            DispatchQueue.main.async { self.hideLoading() }
        })
    }

    func allowUserToProceed(with user: User, profile: UserProfile, subscription: UserSubscription) {
hideLoading()
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
