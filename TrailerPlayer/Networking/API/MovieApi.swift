//
//  ListApi.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 29/01/21.
//

import Foundation

class MovieApi {
    
    static func getMovieList(id: ListId,
                             classificationId: Int,
                             marketCode: String,
                             locale: String,
                             completion: @escaping ((_ data: MovieList?,_ error: Error?) -> Void)) {
        
        var path = "v3/lists/{id}"
        path = path.replacingOccurrences(of: "{id}", with: id.rawValue, options: .literal, range: nil)
        
        let urlString = TPNetworkService.baseURL + path
        
        let parameters: [String : Any] = ["classification_id": classificationId,
                                          "device_identifier": "ios",
                                          "locale": locale,
                                          "market_code": marketCode]
        
        TPNetworkManager(data: parameters, url: urlString, method: .get).executeQuery() {
            
            (result: Result<MovieList ,Error>) in
            
            switch result{
            
            case .success(let response):
                
                completion(response, nil)
                
            case .failure(let error):
                
                completion(nil, error)
                print(error)
            }
        }
    }
    
    static func getMovieDetails(movieId: String,
                                classificationId: Int,
                                marketCode: String,
                                locale: String,
                                completion: @escaping ((_ data: MovieDetail?,_ error: Error?) -> Void)) {
        
        var path = "v3/movies/{id}"
        path = path.replacingOccurrences(of: "{id}", with: movieId, options: .literal, range: nil)
        
        let urlString = TPNetworkService.baseURL + path
        
        let parameters: [String : Any] = ["classification_id": classificationId,
                                          "device_identifier": "ios",
                                          "locale": locale,
                                          "market_code": marketCode]
        
        TPNetworkManager(data: parameters, url: urlString, method: .get).executeQuery() {
            
            (result: Result<MovieDetail ,Error>) in
            
            switch result{
            
            case .success(let response):
                
                completion(response, nil)
                
            case .failure(let error):
                
                completion(nil, error)
                print(error)
            }
        }
    }
}
