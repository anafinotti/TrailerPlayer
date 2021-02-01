//
//  TPMockMovieService.swift
//  TrailerPlayerTests
//
//  Created by Ana Finotti on 31/01/21.
//

import RxSwift

@testable import TrailerPlayer

typealias MovieListResult = TPResult<MovieList, TPResultFailureReason>
typealias MovieDetailsResult = TPResult<MovieDetails, TPResultFailureReason>

final class TPMockMovieService: MovieServiceProtocol {
    
    var getMovieListResult: MovieListResult?
    var getMovieDetailsResult: MovieDetailsResult?
    
    func getMovieList(id: ListId,
                      classificationId: Int,
                      marketCode: String,
                      locale: String) -> Observable<MovieList> {
        
        return Observable.create { observer in
            
            switch self.getMovieListResult {
            
            case .success(let movieList):
                observer.onNext(movieList)
            case .failure(let error):
                observer.onError(error!)
            case .none:
                observer.onError(TPResultFailureReason.notFound)
            }
            
            return Disposables.create()
        }
    }
    
    func getMovieDetails(id: String,
                         classificationId: Int,
                         marketCode: String,
                         locale: String) -> Observable<MovieDetails> {
        
        return Observable.create { observer in
            
            switch self.getMovieDetailsResult {
            
            case .success(let movieDetail):
                observer.onNext(movieDetail)
            case .failure(let error):
                observer.onError(error!)
            case .none:
                observer.onError(TPResultFailureReason.notFound)
            }
            
            return Disposables.create()
        }
    }
}
