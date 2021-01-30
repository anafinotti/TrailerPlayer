//
//  Movie.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 27/01/21.
//

import Foundation

struct Movie: Codable {
    
    let id: String?
    let title: String?
    let images: Images?

    init(id: String? = nil, title: String? = nil, images: Images? = nil) {
        
        self.id = id
        self.title = title
        self.images = images
    }
}
