//
//  MovieResponse.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 30.04.21.
//

import Foundation

struct MovieListResponseObject: Decodable {
    let page: Int
    let results: [MovieResponseItem]?
    let total_pages: Int
    let total_results: Int
}

struct MovieResponseItem: Decodable {
    let adult: Bool
    let backdrop_path: String?
    let genre_ids: [Int]
    let id: Int
    let original_language: String
    let overview: String
    let popularity: Float
    let poster_path: String?
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: Float
    let vote_count: Int
}

struct MovieDetailsResponse: Decodable {
    let adult: Bool
    let budget: Int
    let genres: [GenreResponseObject]
    let id: Int
    let imdb_id: String?
    let overview: String?
    let popularity: Float
    let poster_path: String?
    let production_countries: [ProductionCountriesObjectResponse]
    let release_date: String
    let runtime: Int?
    let status: String
    let title: String
    let video: Bool
    let vote_average: Float
    let vote_count: Int
}

struct ProductionCountriesObjectResponse: Decodable {
    let name: String
    let iso_3166_1: String
}
