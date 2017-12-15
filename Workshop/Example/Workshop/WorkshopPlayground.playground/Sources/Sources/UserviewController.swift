import Foundation
import UIKit
import Workshop
open class UserviewController: UIViewController {
    open var spinner: UIActivityIndicatorView!
    open var getUserButton: UIButton!
    open var gettingUser: UIButton!
    open var gettingUserProfilePic: UIButton!
    open var validatingSubscriptionButton: UIButton!
    open var letsGoButton: UIButton!

    open override func loadView() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white

        self.getUserButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 200),
                button.heightAnchor.constraint(equalToConstant: 50)
                ])
            button.setTitle("Get User", for: .normal)
            button.setBackgroundImage(UIImage.from(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)), for: .normal)
            return button
        }()

        self.gettingUser = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 200),
                button.heightAnchor.constraint(equalToConstant: 50)
                ])
            button.setTitle("Getting User", for: .normal)
            button.setBackgroundImage(UIImage.from(color: #colorLiteral(red: 0, green: 0.6428752542, blue: 0.9320391417, alpha: 1)), for: .normal)
            return button
        }()
        self.gettingUserProfilePic = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 200),
                button.heightAnchor.constraint(equalToConstant: 50)
                ])
            button.setTitle("Getting User Profile", for: .normal)
            button.setBackgroundImage(UIImage.from(color: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)), for: .normal)
            return button
        }()

        self.validatingSubscriptionButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 200),
                button.heightAnchor.constraint(equalToConstant: 50)
                ])
            button.setTitle("Validating Subscription", for: .normal)
            button.setBackgroundImage(UIImage.from(color: #colorLiteral(red: 0.9965399305, green: 0.6379394531, blue: 0.2313725501, alpha: 1)), for: .normal)
            return button
        }()

        self.letsGoButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 200),
                button.heightAnchor.constraint(equalToConstant: 50)
                ])
            button.setTitle("Let's Go!", for: .normal)
            button.setBackgroundImage(UIImage.from(color: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)), for: .normal)
            return button
        }()


        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)

        let stack = UIStackView(arrangedSubviews: [
            spinner,
            getUserButton,
            gettingUser,
            validatingSubscriptionButton,
            gettingUserProfilePic,
            letsGoButton
            ])
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            ])
        
        self.view = view
    }

    public func animate(animations: @escaping ()->()) {
        UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 300, options: [], animations: {
            animations()
        }, completion: nil)
    }


}




