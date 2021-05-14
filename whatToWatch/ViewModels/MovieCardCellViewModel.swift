//
//  MovieCardCellViewModels.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 5.05.21.
//

import Foundation

struct MovieCardCellViewModel {
    let name: String
    let id: Int
    let posterURL: URL?
    let voteAverage: Float
    let mainGenreName: String
}
