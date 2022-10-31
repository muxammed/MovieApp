// Movie.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// MovieListResponse
struct MovieListResponse: Codable {
    let page: Int?
    let results: [MovieShortDetails]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

/// Result
struct MovieShortDetails: Codable {
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
