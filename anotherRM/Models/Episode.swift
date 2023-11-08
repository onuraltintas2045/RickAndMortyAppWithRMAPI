//
//  Episode.swift
//  anotherRM
//
//  Created by Onur on 3.09.2023.
//

import Foundation


struct Episode: Codable {
    let episode: String
    var characters: [String]
}

struct EpisodeResult: Codable {
    let results: [Episode]
}
