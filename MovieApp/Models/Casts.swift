// Casts.swift
// Copyright © RoadMap. All rights reserved.

/// Casts
struct Casts: Codable {
    let id: Int
    let casts: [Cast]

    enum CodingKeys: String, CodingKey {
        case id
        case casts = "cast"
    }
}

/// Cats
struct Cast: Codable {
    let name: String
    let character: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case profilePath = "profile_path"
        case name, character
    }
}
