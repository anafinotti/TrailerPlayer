//
//  TPMovieListViewModelTests.swift
//  TrailerPlayerTests
//
//  Created by Ana Finotti on 29/01/21.
//

import XCTest
@testable import TrailerPlayer

class TPMovieServiceTests: XCTestCase {

    func testMovieList() {
                
        let expect = XCTestExpectation(description: "callback")

        MovieApi.getMovieList(id: ListId.bestMovieSelection, classificationId: 6, marketCode: "es", locale: "es") { (movieList, error) in

            guard movieList != nil else {

                XCTAssert(false, "Failed to fetch movies list")
                return
            }

            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 3.1)
    }
}
