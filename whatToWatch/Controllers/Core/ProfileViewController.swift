//
//  ProfileViewController.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 27.04.21.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        
        APICaller.shared.getCurrentUserProfile { (result) in
            switch result {
            case .success(let model):
                break
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
