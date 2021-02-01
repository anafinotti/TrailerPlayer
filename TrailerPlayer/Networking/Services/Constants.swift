//
//  Constants.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 30/01/21.
//

enum ListId: String, CaseIterable {
    
    case bestMovieSelection = "free-la-mejor-seleccion-de-peliculas"
    case lastRelease = "cinema-ultimos-estrenos"
    case freeRakutenStories = "free-rakuten-stories"
    case freeActionMovies = "free-peliculas-de-accion"
    case cinema10to20 = "cinema-2010-2020-una-decada-de-cine-compra-desde-3-99"
    case freeComedyMovies = "free-peliculas-de-comedia"
}

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
