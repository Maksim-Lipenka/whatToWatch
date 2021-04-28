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
            createRequest(
                withPath: "/account",
                withQuery: "session_id=\(sessionId)",
                type: .GET
            ) { (baseRequest) in
                let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        let result = try JSONDecoder().decode(UserProfile.self, from: data)
                        print(result)
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
        }
    }
    
    // MARK: - Private
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest(
        withPath urlPath: String?,
        withQuery queryParams: String?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
        guard let path = urlPath else {return}
        guard let url = URL(string: "\(Constants.baseAPIURL)\(path)?api_key=\(Constants.apiKey)&\(queryParams ?? "")") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        completion(request)
    }
}
