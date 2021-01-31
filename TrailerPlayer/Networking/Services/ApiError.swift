//
//  ApiError.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 30/01/21.
//

import Foundation

enum ApiError: Error {
    
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}
