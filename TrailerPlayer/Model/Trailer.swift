//
//  Trailer.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 29/01/21.
//

import Foundation

struct Trailer: Codable {
    
    let subtitleLanguages: [Language]?
    let audioLanguages: [Language]?
    
    enum CodingKeys: String, CodingKey {
        
        case subtitleLanguages = "subtitle_languages"
        case audioLanguages = "audio_languages"
    }
}

struct Language: Codable {
    
    let id: String?
}
