//
//  TPMovieDetailsViewModel.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 27/01/21.
//

import UIKit

class TPMovieDetailsViewModel {
    
    //MARK: - Closures
    var reloadViewClosure: (()->())?
    var playVideoClosure: (()->())?
    
    //MARK: - Properties
    private var movieDetail: MovieDetail = MovieDetail() {
        
        didSet {
            
            self.reloadViewClosure?()
        }
    }
    
    private var streamDetail: Stream = Stream() {
        
        didSet {
            
            self.playVideoClosure?()
        }
    }
    
    var movie: MovieDetail {
        
        return movieDetail
    }
    
    var stream: Stream {
        
        return streamDetail
    }
    
    //MARK: - API Calls
    func fetchMovieDetails(movieId: String, classificationId: Int, marketCode: String, locale: String) {
                
        MovieApi.getMovieDetails(movieId: movieId, classificationId: classificationId, marketCode: marketCode, locale: locale) { (response, error) in
                        
            guard let response = response else { fatalError(error.debugDescription) }
            
            self.movieDetail = response
        }
    }
    
    func fetchMovieStreamings(movieDetail: MovieDetail, classificationId: Int, marketCode: String, locale: String) {
                
        if let movieId = movieDetail.id,
           let trailer = movieDetail.trailers?.first,
           let audioLanguage = trailer.audioLanguages?.first,
           let audioLanguageId = audioLanguage.id,
           let subtitleLanguage = trailer.subtitleLanguages?.first,
           let subtitleLanguageId = subtitleLanguage.id {
            
            StreamApi.getStreamings(movieId: movieId, audioLanguageId: audioLanguageId, subtitleLanguageId: subtitleLanguageId, classificationId: classificationId, marketCode: marketCode, locale: locale) { (response, error) in
                                
                guard let response = response else { fatalError(error.debugDescription) }
                
                self.streamDetail = response
            }
        }
    }
}
