//: [Previous](@previous)

import Foundation
import ReactiveSwift
import ReactiveCocoa
import UIKit
import Workshop
import PlaygroundSupport

class NetworkController: UserviewController {

    let hud = MutableProperty<Bool>(false)

    lazy var getUserSubscriptionAction = Action(execute: ReactiveNetwork.getUserSubscriptionStatus)
    lazy var getUserProfileAction = Action(execute: ReactiveNetwork.getUserProfile)
    lazy var getUserAction = Action(execute: ReactiveNetwork.getUser)


    lazy var loadUserAction = Action { [unowned self] in
        return self.getUserAction.apply()
            .flatMap(.latest, { user in
                    SignalProducer.zip(
                        self.getUserSubscriptionAction.apply(user),
                        self.getUserProfileAction.apply(user)
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

        // Loading Setup
        hud <~ loadUserAction.isExecuting

        hud.signal.filter{ $0 == true }.map{ _ in ()}.observeValues(showLoading)
        hud.signal.filter{ $0 == false }.map{ _ in ()}.observeValues(hideLoading)

        // Final points setup
        loadUserAction.values.observeValues(allowUserToProceed)
        loadUserAction.errors.observeValues(showError)

        // Progress setup
        gettingUser.reactive.animatedAlpha <~ getUserAction.isExecuting.map { CGFloat($0 ? 1 : 0) }
        gettingUserProfilePic.reactive.animatedAlpha <~ getUserProfileAction.isExecuting.map { CGFloat($0 ? 1 : 0) }
        validatingSubscriptionButton.reactive.animatedAlpha <~ getUserSubscriptionAction.isExecuting.map { CGFloat($0 ? 1 : 0) }

    }

    @objc func loadUser() {
        loadUserAction.apply().start()
    }

    func showError(error: ActionError<ReactiveNetwork.Error>) {
        print("Failure \(error)")
    }

    func allowUserToProceed(with user: User, profile: UserProfile, subscription: UserSubscription) {
        UIView.animate(withDuration: 0.3, animations: {
            self.letsGoButton.alpha = 1
        })

        UIView.animate(withDuration: 0.3, delay: 4, options: [], animations: {
            self.letsGoButton.alpha = 0
        },completion: nil)

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

extension Reactive where Base: UIView {
    /// Sets the alpha value of the view.
    public var animatedAlpha: BindingTarget<CGFloat> {
        return makeBindingTarget { view, alpha in UIView.animate(withDuration: 0.3) { view.alpha = alpha }  }
    }
}

//: [Next](@next)




