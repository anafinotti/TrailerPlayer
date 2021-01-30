//
//  NetworkManager.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import Foundation
import Alamofire

//MARK: Network Environment
enum TPNetworkEnvironment {
    
    case production
}

//MARK: Network Manager
class TPNetworkManager: NSObject {
    
    static let networkEnviroment: TPNetworkEnvironment = .production
    
    var services = TPNetworkService()
    var parameters = Parameters()
    var headers = HTTPHeaders()
    var method: HTTPMethod!
    var urlString : String! = TPNetworkService.baseURL
    var url: String!
    var encoding: ParameterEncoding! = URLEncoding.default
    
    init(data: [String:Any],
         headers: [String:String] = [:],
         url : String,
         method: HTTPMethod? = .get) {
        
        super.init()
        
        data.forEach{ parameters.updateValue($0.value, forKey: $0.key) }
        headers.forEach({ self.headers.add(name: $0.key, value: $0.value) })
        
        self.url = url
        
        self.method = method
    }
    
    func executeQuery<T>(completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
        
        AF.request(url,
                   method: method,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers)
            .responseData(completionHandler: { response in
                
                switch response.result {
                
                case .success(let result):
                    
                    if let code = response.response?.statusCode {
                        
                        switch code {
                        
                        case 200...299:
                            
                            do {
                                
                                completion(.success(try JSONDecoder().decode(T.self, from: result)))
                            }
                            catch let error {
                                
                                print(String(data: result, encoding: .utf8) ?? "nothing received")
                                completion(.failure(error))
                            }
                        default:
                            
                            let error = NSError(domain: response.debugDescription, code: code, userInfo: response.response?.allHeaderFields as? [String: Any])
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    
                    completion(.failure(error))
                }
            })
    }
}
