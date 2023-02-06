//
//  ImdbFilm.swift
//  M18
//
//  Created by Даниил Попов on 05.01.2023.
//

import Foundation

struct ImdbFilm: Decodable {
    var searchType: String
    var expression: String
    var results: [Film]
}

struct Film: Decodable {
    var title: String
    var description: String
    var image: String
}
