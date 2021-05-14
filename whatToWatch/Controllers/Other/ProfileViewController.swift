//
//  ProfileViewController.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 27.04.21.
//

import SDWebImage
import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        if AuthManager.shared.isSignedIn {
            fetchProfile()
        }
        configureModels()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchProfile() {
        APICaller.shared.getCurrentUserProfile { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)
                case.failure(let error):
                    print(error.localizedDescription)
                    self?.failedToGetProfile()
                }
            }
        }
    }
    
    private func updateUI(with model: UserProfile) {
        if let avatarPath = model.avatar.tmdb.avatar_path {
            createTableHeader(with: "https://www.themoviedb.org/t/p/w150_and_h150_face\(avatarPath)", username: model.username)
        }
    }
    
    private func createTableHeader(with string: String?, username: String) {
        guard let urlString = string, let url = URL(string: urlString) else {
            return
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        
        let imageSize: CGFloat = headerView.height/2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, completed: nil)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        
        let usernameView = UITextView()
        usernameView.text = username
        usernameView.backgroundColor = .secondarySystemBackground
        usernameView.textAlignment = .center
        usernameView.font = UIFont.boldSystemFont(ofSize: 20)
        usernameView.frame = CGRect(x: 0, y: imageView.bottom+6, width: headerView.width, height: 40)
        headerView.addSubview(usernameView)
        
        tableView.tableHeaderView = headerView
    }
    
    private func failedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    
    private func configureModels() {
        if AuthManager.shared.isSignedIn {
            sections.append(Section(options: [Option(title: "Overview", handler: { [weak self] in
                DispatchQueue.main.async {
                    self?.viewOverview()
                }
            }),
            Option(title: "Watchlist", handler: { [weak self] in
                DispatchQueue.main.async {
                    self?.viewWatchlist()
                }
            }),
            Option(title: "Favorites", handler: { [weak self] in
                DispatchQueue.main.async {
                    self?.viewFavorites()
                }
            })
            ]))
            
            sections.append(Section(options: [Option(title: "Sign Out", handler: { [weak self] in
                self?.signOutTapped()
            })]))
        } else {
            sections.append(Section(options: [Option(title: "Sign In", handler: { [weak self] in
                self?.viewWelcome()
            })]))
        }
    }
    
    private func signOutTapped() {
        
    }
    
    private func viewWelcome() {
        let welcomeVC = WelcomeViewController()
        welcomeVC.title = "Welcome"
        present(welcomeVC, animated: true)
    }
    
    private func viewOverview() {
        let vc = OverviewViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func viewWatchlist() {
        let vc = WatchlistViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func viewFavorites() {
        let vc = FavoritesViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return AuthManager.shared.isSignedIn ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Call handler for cell
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }

}
