//
//  MovieListProtocol.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import Foundation

protocol TPMovieListProtocol {
    
    func getMovie( at indexPath: IndexPath) -> Movie
    func itemSelected( at indexPath: IndexPath)

    func retrieveNumberOfItems( by section: Int) -> Int
}
