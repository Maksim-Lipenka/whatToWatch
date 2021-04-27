//
//  AuthManager.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 27.04.21.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {
        
    }
    
    var isSignedIn: Bool {
        return true
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
}
