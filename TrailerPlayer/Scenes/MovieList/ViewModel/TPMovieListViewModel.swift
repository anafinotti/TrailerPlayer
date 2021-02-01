//
//  TPMovieListViewModel.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import Foundation
import RxSwift
import RxCocoa

class TPMovieListViewModel {
    
    //MARK: - Properties
    private let movieServiceProtocol: MovieServiceProtocol
    
    let isLoading = BehaviorRelay<Bool>(value: true)
    var selectedMovie: Movie?
    
    lazy var movieList: [MovieList] = {
        
        return [MovieList]()
    }()
    
    //MARK: - Initializer
    init(movieServiceProtocol: MovieServiceProtocol = MovieService()) {
        
        self.movieServiceProtocol = movieServiceProtocol
    }

    //MARK: Layout
    func getNumberOfItems(by section: Int) -> Int {
        
        let listId = ListId.allCases[section]
        
        guard let movies = movieList.filter({ $0.id == listId.rawValue }).first?.movies else { return 0 }
        return movies.count
    }
    
    //MARK: - API Calls
    func fetchMovieList(listId: ListId,
                        classificationId: Int,
                        marketCode: String,
                        locale: String) -> Observable<MovieList> {
        
        movieServiceProtocol.getMovieList(id: listId, classificationId: classificationId, marketCode: marketCode, locale: locale).map {
            
            let movieList = $0
            self.movieList.append(movieList)
            return $0
        }
    }
    
    //MARK: - API Callback
    func getMovieList(_at indexPath: IndexPath) -> Movie {
        
        return getMovie(_at: indexPath)
    }
    
    fileprivate func getMovie(_at indexPath: IndexPath) -> Movie {
        
        let listId = ListId.allCases[indexPath.section]

        let moviesSection = movieList.filter({ $0.id == listId.rawValue }).first
        
        guard let movie = moviesSection?.movies?[indexPath.row] else { fatalError() }
        
        return movie
    }
}
