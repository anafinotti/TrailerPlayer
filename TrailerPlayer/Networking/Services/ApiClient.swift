//
//  ApiClient.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 30/01/21.
//

import RxSwift
import Alamofire
import Foundation

class ApiClient {
        
    static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        
        return Observable<T>.create { observer in
            
            //Alamofire
            let request = AF.request(urlConvertible).responseDecodable { (response: DataResponse<T, AFError>) in
                
                switch response.result {
                
                case .success(let value):
                    
                    //return the value onNext
                    observer.onNext(value)
                    observer.onCompleted()
                    
                case .failure(let error):
                    
                    //return error
                    switch response.response?.statusCode {
                    
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            
            //stop the request
            return Disposables.create {
                
                request.cancel()
            }
        }
    }
}
