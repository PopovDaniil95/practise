//
//  Item.swift
//  M19
//
//  Created by Даниил Попов on 16.01.2023.
//

import Foundation

struct Item: Codable {
    let birth: String?
    let occupation: String?
    let name: String?
    let lastName: String?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case birth = "birth"
        case occupation = "occupation"
        case name = "name"
        case lastName = "lastName"
        case country = "country"
    }
    
    init(birth: String, occupation: String, name: String, lastName: String, country: String) {
        self.birth = birth
        self.occupation = occupation
        self.name = name
        self.lastName = lastName
        self.country = country
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        birth = try values.decodeIfPresent(String.self, forKey: .birth)
        occupation = try values.decodeIfPresent(String.self, forKey: .occupation)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        country = try values.decodeIfPresent(String.self, forKey: .country)
    }
}
