// Movie.swift
// Copyright © RoadMap. All rights reserved.

import CoreGraphics

//
//  Movie.swift
//  MovieApp
//
//  Created by muxammed on 26.10.2022.
//
/// MovieListResponse
struct MovieListResponse: Codable {
    let page: Int?
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

/// Result
struct Result: Codable {
    let backdroPath: String
    let id: Int
    let title: String
    let posterPath: String
    let voteAverage: CGFloat
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case backdroPath = "backdrop_path"
        case posterPath = "poster_path"
        case id, title
    }
}
