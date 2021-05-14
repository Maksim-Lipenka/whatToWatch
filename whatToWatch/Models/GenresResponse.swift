//
//  GenresResponse.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 12.05.21.
//

import Foundation

struct GenresResponse: Decodable {
    let genres: [GenreResponseObject]
}

struct GenreResponseObject: Decodable {
    let id: Int
    let name: String
}
