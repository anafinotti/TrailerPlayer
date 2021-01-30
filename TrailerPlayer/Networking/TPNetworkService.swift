//
//  NetworkService.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import Foundation

// MARK: BaseURL
var baseURL: String {
    
    switch TPNetworkManager.networkEnviroment {
    
        case .production: return "​https://gizmo.rakuten.tv/"
    }
}

// MARK: Services
enum Services : String {
    
    case list = "v3/lists/estrenos-imprescindibles-en-taquilla"
    case detailes = "v3/movies"
}

class NetworkService : NSObject { }
