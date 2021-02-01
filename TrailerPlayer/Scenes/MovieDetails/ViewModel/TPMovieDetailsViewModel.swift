//
//  TPMovieDetailsViewModel.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 27/01/21.
//

import RxSwift
import RxCocoa

class TPMovieDetailsViewModel {
    
    //MARK: - Properties
    private let movieServiceProtocol: MovieServiceProtocol
    private let streamServiceProtocol: StreamServiceProtocol
    
    //MARK: - Initializer
    init(movieServiceProtocol: MovieServiceProtocol = MovieService(),
         streamServiceProtocol: StreamServiceProtocol = StreamService()) {
        
        self.movieServiceProtocol = movieServiceProtocol
        self.streamServiceProtocol = streamServiceProtocol
    }
    
    lazy var movieDetail: MovieDetails = {
        
        return MovieDetails()
    }()
    
    lazy var stream: Stream = {
        
        return Stream()
    }()
    
    //MARK: - API Calls
    func fetchMovieDetails(movieId: String,
                           classificationId: Int,
                           marketCode: String,
                           locale: String) -> Observable<MovieDetails> {
        
        movieServiceProtocol.getMovieDetails(id: movieId,
                                             classificationId: classificationId,
                                             marketCode: marketCode,
                                             locale: locale).map {
                                                
                                                self.movieDetail = $0
                                                return $0
                                             }
    }
    
    func fetchMovieStreamings(movieDetail: MovieDetails,
                              classificationId: Int,
                              marketCode: String,
                              locale: String) -> Observable<Stream> {
        
        if let movieId = movieDetail.id,
           let trailer = movieDetail.trailers?.first,
           let audioLanguage = trailer.audioLanguages?.first,
           let audioLanguageId = audioLanguage.id,
           let subtitleLanguage = trailer.subtitleLanguages?.first,
           let subtitleLanguageId = subtitleLanguage.id {
            
            return streamServiceProtocol.fetchStreamings(movieId: movieId,
                                                         audioLanguageId: audioLanguageId,
                                                         subtitleLanguageId: subtitleLanguageId,
                                                         classificationId: classificationId,
                                                         marketCode: marketCode,
                                                         locale: locale).map {
                                                            
                                                            self.stream = $0
                                                            return $0
                                                         }
        }
        
        return Observable.empty()
    }
}
