//
//  UserProfile.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 27.04.21.
//

import Foundation

struct UserProfile: Decodable {
    let id: Int
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let include_adult: Bool
    let username: String
    let avatar: UserAvatar
}

struct UserAvatar: Decodable {
    let gravatar: UserGravatar
    let tmdb: AvatarPathObject
}

struct UserGravatar: Decodable {
    let hash: String
}

struct AvatarPathObject: Decodable {
    let avatar_path: String?
}
