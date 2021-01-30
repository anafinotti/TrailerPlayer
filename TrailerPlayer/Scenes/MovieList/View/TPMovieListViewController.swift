//
//  TPMovieListViewController.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import UIKit

class TPMovieListViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    lazy var viewModel: TPMovieListViewModel = {
        
        return TPMovieListViewModel()
    }()
    
    var adapter: TPMovieListAdapter!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupCollectionView()
        setupViewModel()
    }
    
    func setupCollectionView() {
        
        adapter = TPMovieListAdapter(delegate: self)
        
        collectionView.collectionViewLayout = adapter.compositionalLayout
        collectionView.delegate = adapter
        collectionView.dataSource = adapter
        collectionView.contentInsetAdjustmentBehavior = .scrollableAxes
        collectionView.register(UINib(nibName: "TPHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TPHeaderCollectionReusableView")
    }
    
    func setupViewModel() {
        
        viewModel.reloadCollectionViewClosure = { [weak self] () in
            
            DispatchQueue.main.async {
                
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.updateLoadingStatusClosure = { [weak self] () in
            
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                
                if isLoading {
                    
                    self?.activityIndicator.startAnimating()
                    self?.activityIndicator.isHidden = false
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        self?.collectionView.alpha = 0.0
                    })
                }
                else {
                    
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        self?.collectionView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.fetchMovieList(arrayListId: ListId.allCases, classificationId: 6, marketCode: "es", locale: "es")
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        
        case "detailsSegue":
            
            let movieDetails = segue.destination as? TPMovieDetailsViewController
            movieDetails?.movie = viewModel.selectedMovie
            
        default:
            break
        }
    }
}

extension TPMovieListViewController: TPMovieListProtocol {
    
    func itemSelected(at indexPath: IndexPath) {
        
        viewModel.selectedMovie = self.viewModel.getMovieList(_at: indexPath)

        DispatchQueue.main.async {

            self.performSegue(withIdentifier: "detailsSegue", sender: nil)
        }
    
    }
    
    func retrieveNumberOfItemsForBestMovieSelection() -> Int {
        
        return viewModel.numberOfItemsForBestMovieSelection
    }
    
    func retrieveNumberOfItemsForLastRelease() -> Int {
        
        return viewModel.numberOfItemsForLastRelease
    }
    
    func retrieveNumberOfItemsForFreeRakutenStories() -> Int {
        
        return viewModel.numberOfItemsForFreeRakutenStories
    }
    
    func retrieveNumberOfItemsForFreeActionMovies() -> Int {
        
        return viewModel.numberOfItemsForFreeActionMovies
    }
    
    func retrieveNumberOfItemsForCinema10to20() -> Int {
        
        return viewModel.numberOfItemsForCinema10to20
    }
    
    func retrieveNumberOfItemsForFreeComedyMovies() -> Int {
        
        return viewModel.numberOfItemsForFreeComedyMovies
    }
    
    func getMovie(at indexPath: IndexPath) -> Movie {
        
        return viewModel.getMovieList(_at: indexPath)
    }
}
