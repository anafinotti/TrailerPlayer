//
//  StreamingApi.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 29/01/21.
//

import Foundation

class StreamApi {
    
    static func getStreamings(movieId: String,
                             audioLanguageId: String,
                             subtitleLanguageId: String,
                             classificationId: Int,
                             marketCode: String,
                             locale: String,
                             completion: @escaping ((_ data: Stream?,_ error: Error?) -> Void)) {
        var path = "v3/me/streamings?classification_id={classification_id}&device_identifier={device_identifier}&locale={locale}&market_code={market_code}"
        path = path.replacingOccurrences(of: "{classification_id}", with: String(classificationId), options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{device_identifier}", with: "ios", options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{locale}", with: locale, options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{market_code}", with: marketCode, options: .literal, range: nil)
        
        let urlString = TPNetworkService.baseURL + path
        
        let parameters: [String : Any] = ["device_serial": "AABBCCDDCC112233",
                                          "content_type": "movies",
                                          "video_type": "trailer",
                                          "audio_quality": "2.0",
                                          "player": "ios:PD-NONE",
                                          "device_stream_video_quality": "FHD",
                                          "content_id": movieId,
                                          "audio_language": audioLanguageId,
                                          "subtitle_language": subtitleLanguageId]
        
        TPNetworkManager(data: parameters, url: urlString, method: .post).executeQuery() {
            
            (result: Result<Stream ,Error>) in
            
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
