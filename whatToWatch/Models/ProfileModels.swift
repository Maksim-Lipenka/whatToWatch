//
//  ProfileModels.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 29.04.21.
//

import Foundation

struct Section {
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
