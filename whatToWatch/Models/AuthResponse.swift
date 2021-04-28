//
//  AuthResponse.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 29.04.21.
//

import Foundation

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
