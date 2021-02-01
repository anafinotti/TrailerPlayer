//
//  Result.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 31/01/21.
//

enum TPResult<T, U: Error> {
    
    case success(payload: T)
    case failure(U?)
}

enum TPResultFailureReason: Int, Error {
    case unAuthorized = 401
    case notFound = 404
}
