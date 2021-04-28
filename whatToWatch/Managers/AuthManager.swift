//
//  AuthManager.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 27.04.21.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let apiKey = "726bb0eeee512069630aba2c9a0100a9"
//        static let apiToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MjZiYjBlZWVlNTEyMDY5NjMwYWJhMmM5YTAxMDBhOSIsInN1YiI6IjYwODdkOGVhYjZhYmM0MDAyOThiMDJkNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.82Tb-X8y17xATZJwZOZImfl8ZiMBM9HXo83f2umONjY"
    }
    
    struct RequestTokenResponseObject: Decodable {
        let success: Bool
        let failure: Bool?
        let status_code: Int?
        let status_message: String?
        let expires_at: String?
        let request_token: String?
    }
    
    struct CreateSessionResponseObject: Decodable {
        let success: Bool
        let failure: Bool?
        let status_code: Int?
        let status_message: String?
        let session_id: String?
    }
    
    public var requestTokenURL: URL? {
        let base = "https://api.themoviedb.org/3/authentication/token/new"
        let string = "\(base)?api_key=\(AuthManager.Constants.apiKey)"
        return URL(string: string)
    }
    
    public var signInURL: URL? {
        if let token = self.requestToken {
            let string = "https://www.themoviedb.org/authenticate/\(token)"
            return URL(string: string)
        }
        return nil
    }
    
    public var createSessionURL: URL? {
        let base = "https://api.themoviedb.org/3/authentication/session/new"
        let string = "\(base)?api_key=\(AuthManager.Constants.apiKey)"
    
        return URL(string: string)
        // body: request_token
    }
    
    private init() {
        
    }
    
    var isSignedIn: Bool {
        return false
    }
    
    private var requestToken: String?
    
    private var sessionId: String?
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    
    public func createRequestToken(completion: @escaping (() -> Void)) {
        guard let url = requestTokenURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(RequestTokenResponseObject.self, from: data)
                self.requestToken = result.request_token
                completion()
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    public func requestCreateSession() {
        guard let url = createSessionURL else {
            return
        }
        guard let requestToken = self.requestToken else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let json: [String: Any] = ["request_token": requestToken]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(CreateSessionResponseObject.self, from: data)
                self.sessionId = result.session_id
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
