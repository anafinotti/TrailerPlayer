//
//  Movie.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import UIKit

struct MovieList: Encodable, Decodable {
    
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {

        case movieList = "data"
    }
    
    enum MovieListKeys: String, CodingKey {
    
        case type
        case id
    }

    func encode(to encoder: Encoder) throws {
        
      var container = encoder.container(keyedBy: MovieListKeys.self)
        
      try container.encode(type, forKey: .type)
      try container.encode(id, forKey: .id)
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let movies = try values.nestedContainer(keyedBy: MovieListKeys.self, forKey: .movieList)
        
        self.type = try movies.decode(String.self, forKey: .type)
        self.id = try movies.decode(String.self, forKey: .id)
    }
}

struct Movie: Codable {
    
    let id: String
    let title: String
}

