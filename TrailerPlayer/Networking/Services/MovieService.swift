//
//  MovieService.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 30/01/21.
//

import Foundation
import RxSwift

protocol MovieServiceProtocol {
        
    func getMovieList(id: ListId,
                      classificationId: Int,
                      marketCode: String,
                      locale: String) -> Observable<MovieList>
    
    func getMovieDetails(id: String,
                         classificationId: Int,
                         marketCode: String,
                         locale: String) -> Observable<MovieDetail>
}

class MovieService : MovieServiceProtocol {
    
    func getMovieList(id: ListId,
                      classificationId: Int,
                      marketCode: String,
                      locale: String) -> Observable<MovieList> {
        
        let url = ApiRouter.getMovieList(id: id, classificationId: classificationId, marketCode: marketCode, locale: locale)
        
        return ApiClient.request(url)
    }
    
    func getMovieDetails(id: String,
                         classificationId: Int,
                         marketCode: String,
                         locale: String) -> Observable<MovieDetail> {
        
        let url = ApiRouter.getMovieDetails(id: id, classificationId: classificationId, marketCode: marketCode, locale: locale)
        
        return ApiClient.request(url)
    }
}
