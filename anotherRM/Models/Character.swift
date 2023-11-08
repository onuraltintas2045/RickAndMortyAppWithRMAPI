//
//  Character.swift
//  anotherRM
//
//  Created by Onur on 1.09.2023.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    //let type: String?
    let gender: String
    let image: String
    var episode: [String]
    //let url: String
    //let created: String
    func getCharacterStatus() -> String{
        
        return self.species
    }
}

struct CharacterResponse: Codable {
    let results: [Character]
}
