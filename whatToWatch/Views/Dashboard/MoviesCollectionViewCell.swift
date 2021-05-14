//
//  MovieCollectionViewCell.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 5.05.21.
//

import UIKit
import SDWebImage

enum MoviesCollectionViewCellIdentifier: String {
    case popular = "PopularMoviesCollectionViewCell"
    case upcoming = "UpcomingMoviesCollectionViewCell"
    case trending = "TrendingMoviesCollectionViewCell"
    case topRated = "TopRatedMoviesCollectionViewCell"
}

class MoviesCollectionViewCell: UICollectionViewCell {
    private let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerCurve = .continuous
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let movieName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    private let movieGenreName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private let movieVoteAverage: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerCurve = .continuous
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.addSubview(moviePosterImageView)
        contentView.addSubview(movieName)
        contentView.addSubview(movieGenreName)
        contentView.addSubview(movieVoteAverage)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieName.sizeToFit()
        movieVoteAverage.sizeToFit()
        movieGenreName.sizeToFit()
        
        moviePosterImageView.translatesAutoresizingMaskIntoConstraints = false
        movieName.translatesAutoresizingMaskIntoConstraints = false
        movieGenreName.translatesAutoresizingMaskIntoConstraints = false
        movieVoteAverage.translatesAutoresizingMaskIntoConstraints = false
        
        moviePosterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        moviePosterImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.5).isActive = true
        moviePosterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        movieName.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 8).isActive = true
        movieName.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        movieName.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        movieGenreName.topAnchor.constraint(equalTo: movieName.bottomAnchor, constant: 2).isActive = true
        movieGenreName.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        movieName.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        movieVoteAverage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
        movieVoteAverage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: -4).isActive = true
        movieVoteAverage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        movieVoteAverage.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieName.text = nil
        movieVoteAverage.text = nil
        moviePosterImageView.image = nil
        movieGenreName.text = nil
    }
    
    func configure(with viewModel: MovieCardCellViewModel) {
        movieName.text = viewModel.name
        movieGenreName.text = viewModel.mainGenreName.lowercased()
        movieVoteAverage.text = String(viewModel.voteAverage)
        if viewModel.voteAverage <= 5 {
            movieVoteAverage.backgroundColor = .systemRed
        } else if viewModel.voteAverage < 7 {
            movieVoteAverage.backgroundColor = .systemGray
        } else {
            movieVoteAverage.backgroundColor = .systemGreen
        }
        
        moviePosterImageView.sd_setImage(with: viewModel.posterURL, completed: nil)
    }
}
