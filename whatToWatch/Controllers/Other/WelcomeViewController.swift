//
//  WelcomeViewController.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 27.04.21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign in with TMDb", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Later", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "whatToWatch?"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        view.addSubview(skipButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(didTapSkip), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50
        )
        skipButton.frame = CGRect(
            x: 20,
            y: view.height-110-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50
        )
    }
    
    @objc func didTapSkip() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        present(vc, animated: true, completion: nil)
    }
    
    private func handleSignIn(success: Bool) {
        // Log user in or yell at them for error
        guard success else {
            print("dfdfd")
            let alert = UIAlertController(
                title: "Oops",
                message: "Something went wrong when signing in.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        print("here")
        self.dismiss(animated: true, completion: nil)
    }
}
