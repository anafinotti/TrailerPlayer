//
//  MovieListAdapter.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import UIKit

enum Section: Int {
    
    case bestMovieSelection
    case lastRelease
    case freeRakutenStories
    case freeActionMovies
    case cinema10to20
    case freeComedyMovies
}

class TPMovieListAdapter: NSObject {
    
    lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        
        let layout = UICollectionViewCompositionalLayout { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            return self?.setupSection()
        }
        
        return layout
    }()
    
    let delegate: TPMovieListProtocol
    
    //MARK: Constructor
    init(delegate: TPMovieListProtocol) {
        
        self.delegate = delegate
    }
    
    //MARK: - Layout
    func setupSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               
                                               heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 8.0, bottom: 0.0, trailing: 8.0)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                               heightDimension: .estimated(240)),
            subitem: item,
            count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerView = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        headerView.pinToVisibleBounds = true
        
        section.boundarySupplementaryItems = [headerView]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 16.0,
                                                        leading: 0.0,
                                                        bottom: 16.0,
                                                        trailing: 0.0)
        
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        return section
    }
}

//MARK: - UICollectionView DataSource
extension TPMovieListAdapter: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch Section(rawValue: section) {
        
        case .bestMovieSelection:
            return delegate.retrieveNumberOfItemsForBestMovieSelection()
            
        case .cinema10to20:
            return delegate.retrieveNumberOfItemsForCinema10to20()
            
        case .freeActionMovies:
            return delegate.retrieveNumberOfItemsForFreeActionMovies()
            
        case .freeComedyMovies:
            return delegate.retrieveNumberOfItemsForFreeComedyMovies()
            
        case .freeRakutenStories:
            return delegate.retrieveNumberOfItemsForFreeRakutenStories()
            
        case .lastRelease:
            return delegate.retrieveNumberOfItemsForLastRelease()
            
        case .none:
            fatalError("Should not be none")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TPMovieCollectionViewCell", for: indexPath) as? TPMovieCollectionViewCell else { fatalError("Cell not in Storyboard") }
        
        cell.movie = delegate.getMovie(at: indexPath)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TPHeaderCollectionReusableView", for: indexPath) as? TPHeaderCollectionReusableView else { fatalError() }
            
            switch Section(rawValue: indexPath.section) {
            
            case .bestMovieSelection:
                headerView.title = "Best movies selection"
                
            case .cinema10to20:
                headerView.title = "Cinema 2010 - 2020"
                
            case .freeActionMovies:
                headerView.title = "Free action movies"
                
            case .freeComedyMovies:
                headerView.title = "Free comedy movies"
                
            case .freeRakutenStories:
                headerView.title = "Free Rakuten stories"
                
            case .lastRelease:
                headerView.title = "Last release"
                
            case .none:
                fatalError("Should not be none")
            }
            
            return headerView
            
        }
        else { return UICollectionReusableView() }
    }
}

//MARK: - UICollectionView Delegate
extension TPMovieListAdapter: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate.itemSelected(at: indexPath)
    }
}

//MARK: - UICollectionView FlowLayout
extension TPMovieListAdapter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
    }
}
