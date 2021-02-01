//
//  TPMovieListViewModelTests.swift
//  TrailerPlayerTests
//
//  Created by Ana Finotti on 31/01/21.
//

import XCTest
import RxSwift

@testable import TrailerPlayer

class TPMovieListViewModelTests: XCTestCase {
    
    var viewController: TPMovieListViewController!
    
    override func setUp() {
        
        super.setUp()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Movie", bundle: nil)
        
        viewController = storyboard.instantiateViewController(withIdentifier: "TPMovieListViewController") as? TPMovieListViewController
        
        _ = viewController.view
    }
    
    func testCanInstantiateViewController() {
        
        XCTAssertNotNil(viewController)
    }
    
    func testIfCollectionViewIsNotNilAfterViewDidLoad() {
        
        XCTAssertNotNil(viewController.collectionView)
    }
    
    func testFetchMovieList() {
        
        let disposeBag = DisposeBag()
        
        let mockMovieService = TPMockMovieService()
        mockMovieService.getMovieListResult = .success(payload: MovieList(type: "movies", id: "matrix", movies: [Movie(id: "matrix", title: "Matrix", images: Images(artwork: "", snapshot: ""))]))
        
        let viewModel = TPMovieListViewModel(movieServiceProtocol: mockMovieService)
        
        let expectFetchMovieList = expectation(description: "movie list fetched")
        
        viewModel.fetchMovieList(listId: ListId.bestMovieSelection, classificationId: 63, marketCode: "es", locale: "es").subscribe(onNext: { response in
            
            XCTAssertNotNil(viewModel.movieList)
            expectFetchMovieList.fulfill()
        })
        .disposed(by: disposeBag)
        
        wait(for: [expectFetchMovieList], timeout: 0.1)
    }
    
    func testErrorFetchingMovieList() {
        
        let disposeBag = DisposeBag()
        
        let mockMovieService = TPMockMovieService()
        mockMovieService.getMovieListResult = .failure(.notFound)
        
        let viewModel = TPMovieListViewModel(movieServiceProtocol: mockMovieService)
        
        let expectFetchMovieList = expectation(description: "server error not found")
        
        viewModel.fetchMovieList(listId: ListId.bestMovieSelection, classificationId: 63, marketCode: "es", locale: "es").subscribe(onNext: { response in
        },
        onError: { (error) in
            
            expectFetchMovieList.fulfill()
        })
        .disposed(by: disposeBag)
        
        wait(for: [expectFetchMovieList], timeout: 0.1)
    }
}
