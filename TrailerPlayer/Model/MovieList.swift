//
//  Movie.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import UIKit

struct MovieList: Encodable, Decodable {
    
    let type: String?
    let id: String?
    let movies: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        
        case movieList = "data"
    }
    
    enum MovieListKeys: String, CodingKey {
        
        case type
        case id
        case contents = "contents"
        case movies = "data"
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: MovieListKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let movieList = try values.nestedContainer(keyedBy: MovieListKeys.self, forKey: .movieList)
        let contents = try movieList.nestedContainer(keyedBy: MovieListKeys.self, forKey: .contents)
        
        self.type = try movieList.decode(String.self, forKey: .type)
        self.id = try movieList.decode(String.self, forKey: .id)
        
        self.movies = try contents.decode([Movie].self, forKey: .movies)
    }
    
    init(type: String? = nil, id: String? = nil, movies: [Movie]? = nil) {
        
        self.type = type
        self.id = id
        self.movies = movies
    }
}
