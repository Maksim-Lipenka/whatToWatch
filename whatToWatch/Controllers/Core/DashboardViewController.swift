//
//  ViewController.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 27.04.21.
//

import UIKit

enum MovieSectionType {
    case popularMovies(viewModels: [MovieCardCellViewModel])
    case upcomingMovies(viewModels: [MovieCardCellViewModel])
    case trendingMovies(viewModels: [MovieCardCellViewModel])
    case topRatedMovies(viewModels: [MovieCardCellViewModel])
}

class DashboardViewController: UIViewController{
    //    let collectionView: UICollectionView = {
    //        viewLayout.itemSize = CGSize(width: 110, height: 200)
    //    }()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection in
            return DashboardViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let itemWidth: CGFloat = 110;
        let itemHeight: CGFloat = 200;
        let groupHeight = itemHeight;
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(itemHeight)
        ))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
            widthDimension: item.layoutSize.widthDimension,
            heightDimension: .absolute(groupHeight)
        ), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 24, trailing: 6)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerElement]
        
        return section
    }
    
    private var sections = [MovieSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dashboard"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(didTapProfile))
        
        if !AuthManager.shared.isSignedIn {
            let welcomeVC = WelcomeViewController()
            welcomeVC.title = "Welcome"
            present(welcomeVC, animated: true)
        }
        //        createMoviesSection()
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCellIdentifier.popular.rawValue)
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCellIdentifier.upcoming.rawValue)
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCellIdentifier.trending.rawValue)
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCellIdentifier.topRated.rawValue)
        
        collectionView.register(
            MoviesHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MoviesHeaderCollectionReusableViewIdentifier.popular.rawValue
        )
        collectionView.register(
            MoviesHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MoviesHeaderCollectionReusableViewIdentifier.upcoming.rawValue
        )
        collectionView.register(
            MoviesHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MoviesHeaderCollectionReusableViewIdentifier.trending.rawValue
        )
        collectionView.register(
            MoviesHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MoviesHeaderCollectionReusableViewIdentifier.topRated.rawValue
        )
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        
        var genresResult: GenresResponse?
        var upcomingMoviesResult: MovieListResponseObject?
        var popularMoviesResult: MovieListResponseObject?
        var trendingMoviesResult: MovieListResponseObject?
        var topRatedMoviesResult: MovieListResponseObject?
        
        APICaller.shared.getGenres { (result) in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                genresResult = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getPopularMovies(page: 1) { (result) in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                popularMoviesResult = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getUpcomingMovies(page: 1) { (result) in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                upcomingMoviesResult = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getTrendingMovies(page: 1) { (result) in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                trendingMoviesResult = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getTopRatedMovies(page: 1) { (result) in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model):
                print(model)
                topRatedMoviesResult = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) {
            guard let genres = genresResult?.genres,
                  let popularMovies = popularMoviesResult?.results,
                  let upcomingMovies = upcomingMoviesResult?.results,
                  let trendingMovies = trendingMoviesResult?.results,
                  let topRatedMovies = topRatedMoviesResult?.results
            else {
                return
            }
            
            self.configureModels(
                popularMovies: popularMovies,
                upcomingMovies: upcomingMovies,
                trendingMovies: trendingMovies,
                topRatedMovies: topRatedMovies,
                genres: genres
            )
        }
        
    }
    
    private func configureModels(popularMovies: [MovieResponseItem], upcomingMovies: [MovieResponseItem], trendingMovies: [MovieResponseItem], topRatedMovies: [MovieResponseItem], genres: [GenreResponseObject]) {
        // Configure Models
        sections.append(.popularMovies(viewModels: popularMovies.compactMap({ movie in
            return MovieCardCellViewModel(name: movie.title,
                                          id: movie.id,
                                          posterURL: URL(string: "https://www.themoviedb.org/t/p/w1280\(movie.poster_path ?? "")"),
                                          voteAverage: movie.vote_average,
                                          mainGenreName: genres.filter({ (genre) -> Bool in
                                            return genre.id == movie.genre_ids[0]
                                          })[0].name)
        })))
        sections.append(.upcomingMovies(viewModels: upcomingMovies.compactMap({ movie in
            return MovieCardCellViewModel(name: movie.title,
                                          id: movie.id,
                                          posterURL: URL(string: "https://www.themoviedb.org/t/p/w1280\(movie.poster_path ?? "")"),
                                          voteAverage: movie.vote_average,
                                          mainGenreName: genres.filter({ (genre) -> Bool in
                                            return genre.id == movie.genre_ids[0]
                                          })[0].name)
        })))
        sections.append(.trendingMovies(viewModels: trendingMovies.compactMap({ movie in
            return MovieCardCellViewModel(name: movie.title,
                                          id: movie.id,
                                          posterURL: URL(string: "https://www.themoviedb.org/t/p/w1280\(movie.poster_path ?? "")"),
                                          voteAverage: movie.vote_average,
                                          mainGenreName: genres.filter({ (genre) -> Bool in
                                            return genre.id == movie.genre_ids[0]
                                          })[0].name)
        })))
        sections.append(.topRatedMovies(viewModels: topRatedMovies.compactMap({ movie in
            return MovieCardCellViewModel(name: movie.title,
                                          id: movie.id,
                                          posterURL: URL(string: "https://www.themoviedb.org/t/p/w1280\(movie.poster_path ?? "")"),
                                          voteAverage: movie.vote_average,
                                          mainGenreName: genres.filter({ (genre) -> Bool in
                                            return genre.id == movie.genre_ids[0]
                                          })[0].name)
        })))
        collectionView.reloadData()
    }
    
    @objc func didTapProfile() {
        let vc = ProfileViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .popularMovies(let viewModels):
            return viewModels.count
        case .upcomingMovies(let viewModels):
            return viewModels.count
        case .trendingMovies(let viewModels):
            return viewModels.count
        case .topRatedMovies(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        
        switch type {
        case .popularMovies(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCellIdentifier.popular.rawValue, for: indexPath) as? MoviesCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .upcomingMovies(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCellIdentifier.upcoming.rawValue, for: indexPath) as? MoviesCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .trendingMovies(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCellIdentifier.trending.rawValue, for: indexPath) as? MoviesCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .topRatedMovies(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCellIdentifier.topRated.rawValue, for: indexPath) as? MoviesCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let type = sections[indexPath.section]
        var title: String
        
        switch type {
        case .popularMovies:
            title = "Popular Movies"
        case .upcomingMovies:
            title = "Upcoming Movies"
        case .trendingMovies:
            title = "Trending Movies"
        case .topRatedMovies:
            title = "Top Rated Movies"
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MoviesHeaderCollectionReusableViewIdentifier.popular.rawValue, for: indexPath) as? MoviesHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        header.configure(with: title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let section = sections[indexPath.section]
        var movieId: Int
        var movieTitle: String
        switch section {
        case .popularMovies(viewModels: let viewModels):
            movieId = viewModels[indexPath.row].id
            movieTitle = viewModels[indexPath.row].name
        case .upcomingMovies(viewModels: let viewModels):
            movieId = viewModels[indexPath.row].id
            movieTitle = viewModels[indexPath.row].name
        case .trendingMovies(viewModels: let viewModels):
            movieId = viewModels[indexPath.row].id
            movieTitle = viewModels[indexPath.row].name
        case .topRatedMovies(viewModels: let viewModels):
            movieId = viewModels[indexPath.row].id
            movieTitle = viewModels[indexPath.row].name
        }
        
        let vc = MovieDetailsViewController()
        vc.id = movieId
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.navigationItem.backButtonTitle = .none
        vc.navigationItem.title = movieTitle
        navigationController?.pushViewController(vc, animated: true)
    }
}
