//
//  AuthManager.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 27.04.21.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    // MARK: - URL STRINGS
    
    public var requestTokenURL: URL? {
        let base = "https://api.themoviedb.org/3/authentication/token/new"
        let string = "\(base)?api_key=\(APICaller.Constants.apiKey)"
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
        let string = "\(base)?api_key=\(APICaller.Constants.apiKey)"
    
        return URL(string: string)
        // body: request_token
    }
    
    var isSignedIn: Bool {
        return sessionId != nil
    }
    
    private var requestToken: String?
    
    public var sessionId: String? {
        return UserDefaults.standard.string(forKey: "session_id")
    }
    
//    private var tokenExpirationDate: Date? {
//        return nil
//    }
//
//    private var shouldRefreshToken: Bool {
//        return false
//    }
    
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
    
    public func requestCreateSession(completion: @escaping ((Bool) -> Void)) {
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
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(CreateSessionResponseObject.self, from: data)
                self?.cacheSession(result)
                completion(true)
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    private func cacheSession(_ response: CreateSessionResponseObject) {
        UserDefaults.standard.setValue(response.session_id, forKey: "session_id")
    }
}
