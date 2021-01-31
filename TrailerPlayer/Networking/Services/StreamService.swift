//
//  StreamService.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 31/01/21.
//

import Foundation
import RxSwift

protocol StreamServiceProtocol {
    
    func fetchStreamings(movieId: String,
                         audioLanguageId: String,
                         subtitleLanguageId: String,
                         classificationId: Int,
                         marketCode: String,
                         locale: String) -> Observable<Stream>
}

class StreamService: StreamServiceProtocol {
    
    func fetchStreamings(movieId: String,
                         audioLanguageId: String,
                         subtitleLanguageId: String,
                         classificationId: Int,
                         marketCode: String,
                         locale: String) -> Observable<Stream> {
        
        let url = ApiRouter.fetchStreamings(movieId: movieId, audioLanguageId: audioLanguageId, subtitleLanguageId: subtitleLanguageId, classificationId: classificationId, marketCode: marketCode, locale: locale)
        
        return ApiClient.request(url)
    }
}
