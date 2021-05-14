//
//  MoviesHeaderCollectionReusableView.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 13.05.21.
//

import UIKit

enum MoviesHeaderCollectionReusableViewIdentifier: String {
    case popular = "PopularMoviesHeaderCollectionReusableView"
    case upcoming = "UpcomingMovieHeaderCollectionReusableView"
    case trending = "TrendingMoviesHeaderCollectionReusableView"
    case topRated = "TopRatedMoviesHeaderCollectionReusableView"
}

class MoviesHeaderCollectionReusableView: UICollectionReusableView {
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let viewAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("All", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(sectionLabel)
        addSubview(viewAllButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sectionLabel.sizeToFit()
        viewAllButton.sizeToFit()
        
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        sectionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        sectionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        sectionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2/3).isActive = true

        viewAllButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        viewAllButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        viewAllButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sectionLabel.text = nil
    }
    
    func configure(with title: String) {
        sectionLabel.text = title
    }
}
