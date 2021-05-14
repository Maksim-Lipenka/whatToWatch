//
//  MovieDetailsViewController.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 27.04.21.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController {
    var id: Int?
    
    var posterWidthConstraint: NSLayoutConstraint!
    
    private var sideBarMovieDetailsUIView = UIView()
    
    private lazy var posterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.cornerCurve = .continuous
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray
        let action = UITapGestureRecognizer(target: self, action: #selector(onPosterPress))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(action)
        return imageView
    }()
    
    private var scoreUILabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerCurve = .continuous
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        return label
    }()
    
    private var releaseDateUILabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
//        label.textColor = .systemGray
        return label
    }()
    
    private var durationUILabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
//        label.textColor = .systemGray
        return label
    }()
    
    private var genresUILabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 3
        return label
    }()
    
    private var countryUILabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
//        label.textColor = .systemGray
        return label
    }()
    
    private var playTrailerUIButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        let color = UIColor(named: "PrimaryButtonColor")!
        button.setTitle("WATCH TRAILER", for: .normal)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(color.withAlphaComponent(0.7), for: .highlighted)
        button.tintColor = color
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.setImage(UIImage(systemName: "play"), for: .highlighted)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        return button
    }()
    
    @objc private func onPosterPress() {
        if posterWidthConstraint.constant == -16 {
            posterWidthConstraint.constant = -view.width/2
        } else {
            posterWidthConstraint.constant = -16
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    private var overviewUILabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        createUI()
        fetchData()
    }
    
    private func fetchData() {
        if let movieId = id {
            APICaller.shared.getMovieDetails(of: movieId) {[weak self] (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        self?.updateUI(with: model)
                        print(model)
                    case .failure(let error):
                        self?.failedToGetMovie()
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func createUI() {
        view.addSubview(posterUIImageView)
        posterUIImageView.translatesAutoresizingMaskIntoConstraints = false
        posterUIImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        posterUIImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        posterWidthConstraint = posterUIImageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -view.width/2)
        posterWidthConstraint.isActive = true
        posterUIImageView.heightAnchor.constraint(equalTo: posterUIImageView.widthAnchor, multiplier: 1.5).isActive = true
        
        view.addSubview(sideBarMovieDetailsUIView)
        sideBarMovieDetailsUIView.translatesAutoresizingMaskIntoConstraints = false
        sideBarMovieDetailsUIView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        sideBarMovieDetailsUIView.leftAnchor.constraint(equalTo: posterUIImageView.rightAnchor, constant: 8).isActive = true
        sideBarMovieDetailsUIView.heightAnchor.constraint(equalTo: posterUIImageView.heightAnchor, constant: -8).isActive = true
        sideBarMovieDetailsUIView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -24).isActive = true
        
        sideBarMovieDetailsUIView.addSubview(scoreUILabel)
        scoreUILabel.translatesAutoresizingMaskIntoConstraints = false
        scoreUILabel.topAnchor.constraint(equalTo: sideBarMovieDetailsUIView.topAnchor).isActive = true
        scoreUILabel.leftAnchor.constraint(equalTo: sideBarMovieDetailsUIView.leftAnchor).isActive = true
        scoreUILabel.widthAnchor.constraint(equalToConstant: 32).isActive = true
        scoreUILabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        sideBarMovieDetailsUIView.addSubview(releaseDateUILabel)
        releaseDateUILabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateUILabel.topAnchor.constraint(equalTo: sideBarMovieDetailsUIView.topAnchor).isActive = true
        releaseDateUILabel.leftAnchor.constraint(equalTo: scoreUILabel.rightAnchor, constant: 6).isActive = true
        releaseDateUILabel.heightAnchor.constraint(equalTo: scoreUILabel.heightAnchor).isActive = true
        
        sideBarMovieDetailsUIView.addSubview(durationUILabel)
        durationUILabel.translatesAutoresizingMaskIntoConstraints = false
        durationUILabel.topAnchor.constraint(equalTo: sideBarMovieDetailsUIView.topAnchor).isActive = true
        durationUILabel.leftAnchor.constraint(equalTo: releaseDateUILabel.rightAnchor, constant: 6).isActive = true
        durationUILabel.heightAnchor.constraint(equalTo: scoreUILabel.heightAnchor).isActive = true
        
        sideBarMovieDetailsUIView.addSubview(countryUILabel)
        countryUILabel.translatesAutoresizingMaskIntoConstraints = false
        countryUILabel.topAnchor.constraint(equalTo: sideBarMovieDetailsUIView.topAnchor).isActive = true
        countryUILabel.leftAnchor.constraint(equalTo: durationUILabel.rightAnchor, constant: 6).isActive = true
        countryUILabel.heightAnchor.constraint(equalTo: scoreUILabel.heightAnchor).isActive = true
        
        sideBarMovieDetailsUIView.addSubview(genresUILabel)
        genresUILabel.translatesAutoresizingMaskIntoConstraints = false
        genresUILabel.topAnchor.constraint(equalTo: scoreUILabel.bottomAnchor, constant: 8).isActive = true
        genresUILabel.leftAnchor.constraint(equalTo: sideBarMovieDetailsUIView.leftAnchor).isActive = true
        genresUILabel.widthAnchor.constraint(equalTo: sideBarMovieDetailsUIView.widthAnchor).isActive = true
        
        sideBarMovieDetailsUIView.addSubview(playTrailerUIButton)
        playTrailerUIButton.translatesAutoresizingMaskIntoConstraints = false
        playTrailerUIButton.bottomAnchor.constraint(equalTo: sideBarMovieDetailsUIView.bottomAnchor, constant: -8).isActive = true
        playTrailerUIButton.leftAnchor.constraint(equalTo: sideBarMovieDetailsUIView.leftAnchor).isActive = true
        playTrailerUIButton.rightAnchor.constraint(equalTo: sideBarMovieDetailsUIView.rightAnchor).isActive = true
        let playButtonHeightConstraint = playTrailerUIButton.heightAnchor.constraint(equalToConstant: 40)
        playButtonHeightConstraint.isActive = true
        playTrailerUIButton.layer.cornerRadius = playButtonHeightConstraint.constant / 7
        
        view.addSubview(overviewUILabel)
        overviewUILabel.translatesAutoresizingMaskIntoConstraints = false
        overviewUILabel.topAnchor.constraint(equalTo: posterUIImageView.bottomAnchor, constant: 16).isActive = true
        overviewUILabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        overviewUILabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
    }
    
    private func updateUI(with model: MovieDetailsResponse) {
        if let posterPath = model.poster_path, let posterURL = URL(string: "https://www.themoviedb.org/t/p/w1280\(posterPath)") {
            posterUIImageView.sd_setImage(with: posterURL, completed: nil)
        }
        
        scoreUILabel.text = String(model.vote_average)
        if model.vote_average <= 5 {
            scoreUILabel.backgroundColor = .systemRed
        } else if model.vote_average < 7 {
            scoreUILabel.backgroundColor = .systemGray
        } else {
            scoreUILabel.backgroundColor = .systemGreen
        }
        
        releaseDateUILabel.text = String(model.release_date.prefix(4)) + ","
        if let runtime = model.runtime {
            let hours = Int(runtime / 60)
            let minutes = runtime % 60
            durationUILabel.text = "\(hours)h \(minutes)m,"
        }
        
        var genresText = ""
        model.genres.forEach { (genre) in
            genresText += genre.name + ", "
        }
        genresUILabel.text = String(genresText.prefix(genresText.count-2))
        
        if model.production_countries.count != 0 {
            countryUILabel.text = model.production_countries[0].iso_3166_1
        }
        
        if let overview = model.overview {
            let paragraph = NSMutableParagraphStyle()
            paragraph.firstLineHeadIndent = 8
            paragraph.lineSpacing = 2
            let attrOverview = NSAttributedString(string: overview, attributes: [NSAttributedString.Key.paragraphStyle: paragraph])
            overviewUILabel.attributedText = attrOverview
        }
    }
    
    private func failedToGetMovie() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load movie details."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: state)
        }
    }
}
