//
//  MovieListAdapter.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import UIKit

class MovieListAdapter: NSObject {
    
    let delegate: TPMovieListProtocol
    
    //MARK: Constructor
    init(delegate: TPMovieListProtocol) {
        
        self.delegate = delegate
    }
}

//MARK: - TableView Datasource
extension MovieListAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return delegate.numberOfItems()
    }
}

//MARK: - TableView Delegate
extension MovieListAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
