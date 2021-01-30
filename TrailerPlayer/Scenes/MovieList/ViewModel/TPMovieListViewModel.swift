//
//  TPMovieListViewModel.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import UIKit

class TPMovieListViewModel {
    
    // MARK: - Closures
    var reloadCollectionViewClosure: (()->())?
    var updateLoadingStatusClosure: (()->())?
    
    // MARK: - Properties
    var selectedMovie: Movie?

    private var movieList: [MovieList] = [MovieList]() {
        
        didSet {
            
            self.reloadCollectionViewClosure?()
        }
    }
    
    var numberOfItemsForBestMovieSelection: Int {
        
        guard let movies = movieList.filter({ $0.id == ListId.bestMovieSelection.rawValue }).first?.movies else { return 0 }
        
        return movies.count
    }
    
    var numberOfItemsForCinema10to20: Int {
        
        guard let movies = movieList.filter({ $0.id == ListId.cinema10to20.rawValue }).first?.movies else { return 0 }
        
        return movies.count
    }
    
    var numberOfItemsForFreeActionMovies: Int {
        
        guard let movies = movieList.filter({ $0.id == ListId.freeActionMovies.rawValue }).first?.movies else { return 0 }
        
        return movies.count
    }
    
    var numberOfItemsForFreeComedyMovies: Int {
        
        guard let movies = movieList.filter({ $0.id == ListId.freeComedyMovies.rawValue }).first?.movies else { return 0 }
        
        return movies.count
    }
    
    var numberOfItemsForFreeRakutenStories: Int {
                
        guard let movies = movieList.filter({ $0.id == ListId.freeRakutenStories.rawValue }).first?.movies else { return 0 }
        
        return movies.count
    }
    
    var numberOfItemsForLastRelease: Int {
        
        guard let movies = movieList.filter({ $0.id == ListId.lastRelease.rawValue }).first?.movies else { return 0 }
        
        return movies.count
    }
    
    var isLoading: Bool = false {
        
        didSet {
            
            self.updateLoadingStatusClosure?()
        }
    }
    
    //MARK: - Constructor
    
    //MARK: - API Calls
    func fetchMovieList(arrayListId: Array<ListId>, classificationId: Int, marketCode: String, locale: String) {
        
        self.isLoading = true
        
        var copyArrayListId = arrayListId
        
        guard let currentListId = copyArrayListId.first else { fatalError("No list id.") }
        
        copyArrayListId.removeFirst()
        
        MovieApi.getMovieList(id: currentListId, classificationId: classificationId, marketCode: marketCode, locale: locale) { (movie, error) in
            
            guard let movie = movie else { fatalError(error.debugDescription) }
                        
            self.movieList.append(movie)
            
            guard copyArrayListId.count > 0 else {
                
                self.isLoading = false
                return
            }
                            
            self.fetchMovieList(arrayListId: copyArrayListId, classificationId: classificationId, marketCode: marketCode, locale: locale)

        }
    }
    
    //MARK: - API Callback
    fileprivate func getMovie(_at indexPath: IndexPath, listId: ListId) -> Movie {
        
        let moviesSection = movieList.filter({ $0.id == listId.rawValue }).first
        
        guard let movie = moviesSection?.movies?[indexPath.row] else { fatalError() }
        
        return movie
    }
    
    func getMovieList(_at indexPath: IndexPath) -> Movie {
        
        switch Section(rawValue: indexPath.section) {
        
        case .bestMovieSelection:
            
            return getMovie(_at: indexPath, listId: .bestMovieSelection)
            
        case .cinema10to20:
            
            return getMovie(_at: indexPath, listId: .cinema10to20)
            
        case .freeActionMovies:
            
            return getMovie(_at: indexPath, listId: .freeActionMovies)
            
        case .freeComedyMovies:
            
            return getMovie(_at: indexPath, listId: .freeComedyMovies)
            
        case .freeRakutenStories:
            
            return getMovie(_at: indexPath, listId: .freeRakutenStories)
            
        case .lastRelease:
            
            return getMovie(_at: indexPath, listId: .lastRelease)
            
        case .none:
            fatalError("Should not be none")
        }
    }
}
