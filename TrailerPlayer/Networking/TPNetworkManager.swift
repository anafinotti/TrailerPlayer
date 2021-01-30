//
//  NetworkManager.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import Foundation
import Alamofire

//MARK: Network Environment
enum NetworkEnvironment {
    
    case production
}

//MARK: Network Manager
class TPNetworkManager: NSObject {
    
    static let networkEnviroment: NetworkEnvironment = .production
    
    var services = NetworkService()
    var parameters = Parameters()
    var headers = HTTPHeaders()
    var method: HTTPMethod!
    var urlString : String! = baseURL
    var url: URL!
    var encoding: ParameterEncoding! = URLEncoding.default
    
    init(data: [String:Any],
         headers: [String:String] = [:],
         url : String?,
         service :Services? = nil,
         method: HTTPMethod? = .get,
         isJSONRequest: Bool = true) {
        
        super.init()
        
        data.forEach{ parameters.updateValue($0.value, forKey: $0.key) }
        headers.forEach({ self.headers.add(name: $0.key, value: $0.value) })
        
        if let service = service,
           url == nil {
            
            self.urlString += service.rawValue
        }
        else { self.urlString = url }
        
        if !isJSONRequest {
            

            
            encoding = URLEncoding.default
        }
        if let encoded = urlString?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: encoded) {

            self.url = url
        }

        self.method = method
        
        print("Service: \(service?.rawValue ?? self.urlString ?? "") \n data: \(parameters)")
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
