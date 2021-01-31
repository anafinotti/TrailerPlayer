//
//  ApiRouter.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 30/01/21.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    
    case getMovieList(id: ListId,
                      classificationId: Int,
                      marketCode: String,
                      locale: String)
    
    case getMovieDetails(id: String,
                         classificationId: Int,
                         marketCode: String,
                         locale: String)
    
    case fetchStreamings(movieId: String,
                         audioLanguageId: String,
                         subtitleLanguageId: String,
                         classificationId: Int,
                         marketCode: String,
                         locale: String)
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
        let baseUrl = try Constants.baseUrl.asURL()
        
        guard let urlString = baseUrl.appendingPathComponent(path).absoluteString.removingPercentEncoding else { fatalError("wrong url format") }
        guard let url = URL(string: urlString) else { fatalError("wrong url format") }
        
        var urlRequest = URLRequest(url: url)
        
        //Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        
        //Encoding
        let encoding: ParameterEncoding = {
            
            switch method {
            
            case .get:
                return URLEncoding.default
                
            case .post:
                return JSONEncoding.default
                
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    private var method: HTTPMethod {
        
        switch self {
        
        case .getMovieList:
            return .get
            
        case .getMovieDetails:
            return .get
            
        case .fetchStreamings:
            return .post
        }
    }
    
    //MARK: - Path
    private var path: String {
        
        switch self {
        
        case .getMovieList(let id, _, _, _):
            
            var path = "v3/lists/{id}"
            
            path = path.replacingOccurrences(of: "{id}", with: id.rawValue, options: .literal, range: nil)
            
            return path
            
        case .getMovieDetails(let id, _, _, _):
            
            var path = "v3/movies/{id}"
            
            path = path.replacingOccurrences(of: "{id}", with: id, options: .literal, range: nil)
            
            return path
            
        case .fetchStreamings(_ , _, _,
                              let classificationId,
                              let marketCode,
                              let locale):
            
            var path = "v3/me/streamings?classification_id={classification_id}&device_identifier={device_identifier}&locale={locale}&market_code={market_code}"
            
            path = path.replacingOccurrences(of: "{classification_id}", with: String(classificationId), options: .literal, range: nil)
            path = path.replacingOccurrences(of: "{device_identifier}", with: "ios", options: .literal, range: nil)
            path = path.replacingOccurrences(of: "{locale}", with: locale, options: .literal, range: nil)
            path = path.replacingOccurrences(of: "{market_code}", with: marketCode, options: .literal, range: nil)
            
            return path
        }
    }
    
    //MARK: - Parameters
    private var parameters: Parameters? {
        
        switch self {
        
        case .getMovieList( _, let classificationId, let marketCode, let locale):
            
            return ["classification_id": classificationId,
                    "device_identifier": "ios",
                    "locale": locale,
                    "market_code": marketCode]
            
        case .getMovieDetails( _, let classificationId, let marketCode, let locale):
            
            return ["classification_id": classificationId,
                    "device_identifier": "ios",
                    "locale": locale,
                    "market_code": marketCode]
            
        case .fetchStreamings(let movieId,
                              let audioLanguageId,
                              let subtitleLanguageId, _, _, _):
            
            return ["device_serial": "AABBCCDDCC112233",
                    "content_type": "movies",
                    "video_type": "trailer",
                    "audio_quality": "2.0",
                    "player": "ios:PD-NONE",
                    "device_stream_video_quality": "FHD",
                    "content_id": movieId,
                    "audio_language": audioLanguageId,
                    "subtitle_language": subtitleLanguageId]
        }
    }
}
