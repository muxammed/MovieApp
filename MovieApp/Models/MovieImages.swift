// MovieImages.swift
// Copyright © RoadMap. All rights reserved.

//
//  MovieImages.swift
//  MovieApp
//
//  Created by muxammed on 28.10.2022.
//
/// MovieImages
struct MovieImages: Codable {
    let logos: [MovieImage]
}

/// MovieImage
struct MovieImage: Codable {
    let filePath: String?
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}
