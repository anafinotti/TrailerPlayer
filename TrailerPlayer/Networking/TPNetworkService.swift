//
//  NetworkService.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import Foundation

enum ListId: String, CaseIterable {
    
    case bestMovieSelection = "free-la-mejor-seleccion-de-peliculas"
    case lastRelease = "cinema-ultimos-estrenos"
    case freeRakutenStories = "free-rakuten-stories"
    case freeActionMovies = "free-peliculas-de-accion"
    case cinema10to20 = "cinema-2010-2020-una-decada-de-cine-compra-desde-3-99"
    case freeComedyMovies = "free-peliculas-de-comedia"
}

class TPNetworkService {

    // MARK: BaseURL
    static var baseURL: String {
        
        switch TPNetworkManager.networkEnviroment {
        
        case .production:
            return "https://gizmo.rakuten.tv/"
        }
    }
}
