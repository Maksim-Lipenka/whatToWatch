//
//  APICaller.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 27.04.21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.themoviedb.org/3"
        static let apiKey = "726bb0eeee512069630aba2c9a0100a9"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        if let sessionId = AuthManager.shared.sessionId {
            createRequest(withPath: "/account", withQuery: "session_id=\(sessionId)", type: .GET, completion)
        }
    }
    
    public func getGenres(completion: @escaping ((Result<GenresResponse, Error>)) -> Void) {
        createRequest(withPath: "/genre/movie/list", withQuery: nil, type: .GET, completion)
    }
    
    public func getPopularMovies(page: Int?, completion: @escaping ((Result<MovieListResponseObject, Error>)) -> Void) {
        createRequest(withPath: "/movie/popular", withQuery: "page=\(page ?? 1)", type: .GET, completion)
    }
    
    public func getTopRatedMovies(page: Int?, completion: @escaping ((Result<MovieListResponseObject, Error>)) -> Void) {
        createRequest(withPath: "/movie/top_rated", withQuery: "page=\(page ?? 1)", type: .GET, completion)
    }
    
    public func getUpcomingMovies(page: Int?, completion: @escaping ((Result<MovieListResponseObject, Error>)) -> Void) {
        createRequest(withPath: "/movie/upcoming", withQuery: "page=\(page ?? 1)", type: .GET, completion)
    }
    
    public func getTrendingMovies(page: Int?, completion: @escaping ((Result<MovieListResponseObject, Error>)) -> Void) {
        createRequest(withPath: "/trending/movie/week", withQuery: "page=\(page ?? 1)", type: .GET, completion)
    }
    
    public func getFavoriteMovies(page: Int?, completion: @escaping ((Result<MovieListResponseObject, Error>)) -> Void) {
        if let sessionId = AuthManager.shared.sessionId {
            createRequest(withPath: "/account/10436251/favorite/movies", withQuery: "page=\(page ?? 1)&session_id=\(sessionId)", type: .GET, completion)
        }
    }
    
    public func getMovieDetails(of movieId: Int, completion: @escaping ((Result<MovieDetailsResponse, Error>)) -> Void) {
        createRequest(withPath: "/movie/\(movieId)", withQuery: nil, type: .GET, completion)
    }
    
    // MARK: - Private
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest<T: Decodable>(
        withPath urlPath: String,
        withQuery queryParams: String?,
        type: HTTPMethod,
        _ completion: @escaping ((Result<T, Error>)) -> Void
    ) {
        guard let url = URL(string: "\(Constants.baseAPIURL)\(urlPath)?api_key=\(Constants.apiKey)&\(queryParams ?? "")") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
//                print(try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed))
                let result = try JSONDecoder().decode(T.self, from: data)
//                print(result)
                completion(.success(result))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
