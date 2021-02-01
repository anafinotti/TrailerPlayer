//
//  TPMovieDetailsViewModelTests.swift
//  TrailerPlayerTests
//
//  Created by Ana Finotti on 31/01/21.
//

import XCTest
import RxSwift

@testable import TrailerPlayer

class TPMovieDetailsViewModelTests: XCTestCase {
    
    var viewController: TPMovieDetailsViewController!
    
    override func setUp() {
        
        super.setUp()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Movie", bundle: nil)
        
        viewController = storyboard.instantiateViewController(withIdentifier: "TPMovieDetailsViewController") as? TPMovieDetailsViewController
        
        _ = viewController.view
    }

    func testCanInstantiateViewController() {
        
        XCTAssertNotNil(viewController)
    }
    
    func testFetchMovieDetails() {
        
        let disposeBag = DisposeBag()
        
        let mockMovieService = TPMockMovieService()
        mockMovieService.getMovieDetailsResult = .success(payload: MovieDetails(id: "matrix", title: "Matrix", shortPlot: "lorem ipsum", images: Images(artwork: "", snapshot: ""), trailers: [Trailer]()))
        
        let viewModel = TPMovieDetailsViewModel(movieServiceProtocol: mockMovieService)
        
        let expectFetchMovieList = expectation(description: "movie list fetched")
        
        viewModel.fetchMovieDetails(movieId: "matrix", classificationId: 6, marketCode: "es", locale: "es").subscribe(onNext: { response in
            
            XCTAssertNotNil(viewModel.movieDetail)
            expectFetchMovieList.fulfill()
        })
        .disposed(by: disposeBag)
        
        wait(for: [expectFetchMovieList], timeout: 0.1)
    }
    
    func testIfPlayButtonHasActionAssigned() {
        
        XCTAssertNotNil(viewController.buttonPlay, "ViewController doesn't have UIButton property")
        
        //Attempt Access UIButton Actions
        guard let buttonPlayActions = viewController.buttonPlay.actions(forTarget: viewController, forControlEvent: .touchUpInside) else {
            XCTFail("buttonPlay don't have touchUpInside event")
            return
        }
     
        // Assert UIButton has action with a method name
        XCTAssertTrue(buttonPlayActions.contains("didTapPlayTrailerButton:"))
    }
}
