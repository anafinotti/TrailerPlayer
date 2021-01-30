//
//  MovieListProtocol.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import Foundation

protocol MovieListProtocol {
    
    func getMovieList( at indexPath: IndexPath) -> Movie
    func retrieveNumberOfItems() -> Int

}
