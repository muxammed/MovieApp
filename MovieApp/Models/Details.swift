// Details.swift
// Copyright © RoadMap. All rights reserved.

import CoreGraphics

/// Details
struct Details: Codable {
    let genres: [Genre]
    let overview: String
    let productionCountries: [Country]
    let releaseDate: String
    let runtime: Int
    let voteAverage: CGFloat

    enum CodingKeys: String, CodingKey {
        case genres, overview, runtime
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

/// Country
struct Country: Codable {
    let name: String
}

/// Genre
struct Genre: Codable {
    let id: Int
    let name: String
}
