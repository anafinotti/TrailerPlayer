//
//  Stream.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 29/01/21.
//

import Foundation

struct Stream: Codable {
    
    let id: String?
    let streamInfo: [StreamInfo]?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    enum StreamKeys: String, CodingKey {
        
        case id
        case streamInfo = "stream_infos"
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: StreamKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(streamInfo, forKey: .streamInfo)
    }
    
    init(from decoder: Decoder) throws {
        
        let data = try decoder.container(keyedBy: CodingKeys.self)
        
        let stream = try data.nestedContainer(keyedBy: StreamKeys.self, forKey: .data)
        
        self.id = try stream.decode(String.self, forKey: .id)
        self.streamInfo = try stream.decode([StreamInfo].self, forKey: .streamInfo)
    }
    
    init(id: String? = nil, streamInfo: [StreamInfo]? = nil) {
        
        self.id = id
        self.streamInfo = streamInfo
    }
}

struct StreamInfo: Codable {
    
    let url: String?
}
