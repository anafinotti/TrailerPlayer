//
//  Constants.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 30/01/21.
//

struct Constants {
    
    static let baseUrl = "https://gizmo.rakuten.tv/"
    
    enum HttpHeaderField: String {
        
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContentType: String {
        
        case json = "application/json"
    }
}
