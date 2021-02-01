//
//  MovieDetail.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 27/01/21.
//

import Foundation

struct MovieDetails: Codable {
    
    let id: String?
    let title: String?
    let shortPlot: String?
    let images: Images?
    let trailers: [Trailer]?
    
    init(id: String? = nil, title: String? = nil, shortPlot: String? = nil, images: Images? = nil, trailers: [Trailer]? = nil) {
        
        self.id = id
        self.title = title
        self.shortPlot = shortPlot
        self.images = images
        self.trailers = trailers
    }
    
    enum CodingKeys: String, CodingKey {
        
        case movie = "data"
    }
    
    enum MovieKeys: String, CodingKey {
        
        case id
        case title
        case shortPlot = "short_plot"
        case images
        case viewOptions = "view_options"
    }
    
    enum ViewOptionsKeys: String, CodingKey {
        
        case publicContent = "public"
    }
    enum TrailerKeys: String, CodingKey {
        
        case trailers
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let movie = try values.nestedContainer(keyedBy: MovieKeys.self, forKey: .movie)
        
        let viewOptions = try movie.nestedContainer(keyedBy: ViewOptionsKeys.self, forKey: .viewOptions)
        let publicContent = try viewOptions.nestedContainer(keyedBy: TrailerKeys.self, forKey: .publicContent)
        
        self.id = try movie.decode(String.self, forKey: .id)
        self.title = try movie.decode(String.self, forKey: .title)
        self.shortPlot = try movie.decode(String.self, forKey: .shortPlot)
        self.images = try movie.decode(Images.self, forKey: .images)
        self.trailers = try publicContent.decode([Trailer].self, forKey: .trailers)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: MovieKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(shortPlot, forKey: .shortPlot)
        try container.encode(images, forKey: .images)
    }
}
