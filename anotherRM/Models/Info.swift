//
//  Info.swift
//  anotherRM
//
//  Created by Onur on 1.09.2023.
//

import Foundation

struct InfoResponse: Codable{
    let info: Info
    
    struct Info: Codable{
        let pages: Int
        let count: Int
    }
}
