//
//  TPMovieListViewController.swift
//  TrailerPlayer
//
//  Created by Ana Finotti on 26/01/21.
//

import UIKit
import RxSwift
import RxCocoa

class TPMovieListViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    
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
    
    //MARK: Layout
    func setupCollectionView() {
        
        adapter = TPMovieListAdapter(delegate: self)
        
        collectionView.collectionViewLayout = adapter.compositionalLayout
        collectionView.delegate = adapter
        collectionView.dataSource = adapter
        collectionView.contentInsetAdjustmentBehavior = .scrollableAxes
        collectionView.register(UINib(nibName: "TPHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TPHeaderCollectionReusableView")
    }
    
    func setupViewModel() {
        
        viewModel.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        self.viewModel.isLoading.accept(true)
        
        fetchMovieList(arrayListId: ListId.allCases, classificationId: 6, marketCode: "es", locale: "es")
    }
    
    func fetchMovieList(arrayListId: [ListId],
                        classificationId: Int,
                        marketCode: String,
                        locale: String) {
        
        var copyArrayListId = arrayListId
        
        guard let currentListId = copyArrayListId.first else { fatalError("No list id.") }
        
        copyArrayListId.removeFirst()
        
        viewModel.fetchMovieList(listId: currentListId,
                                 classificationId: classificationId,
                                 marketCode: marketCode,
                                 locale: locale)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { response in
                
                guard copyArrayListId.count > 0 else {
                    
                    self.viewModel.isLoading.accept(false)
                    self.activityIndicator.isHidden = true
                    
                    self.collectionView.reloadData()
                    return
                }
                
                self.fetchMovieList(arrayListId: copyArrayListId, classificationId: classificationId, marketCode: marketCode, locale: locale)
                
            }, onError: { error in
                
                switch error {
                
                case ApiError.conflict:
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
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
    
    func retrieveNumberOfItems(by section: Int) -> Int {
        
        return viewModel.getNumberOfItems(by: section)
    }
    
    func getMovie(at indexPath: IndexPath) -> Movie {
        
        return viewModel.getMovieList(_at: indexPath)
    }
}
