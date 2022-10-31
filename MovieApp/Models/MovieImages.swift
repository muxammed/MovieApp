// MovieImages.swift
// Copyright © RoadMap. All rights reserved.

/// MovieImages
struct MovieImages: Codable {
    let movieLogoImage: [MovieImage]

    enum CodingKeys: String, CodingKey {
        case movieLogoImage = "logos"
    }
}

/// MovieImage
struct MovieImage: Codable {
    let movieImagePath: String?
    enum CodingKeys: String, CodingKey {
        case movieImagePath = "file_path"
    }
}
