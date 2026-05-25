//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Adilkhan on 25/5/26.
//

import XCTest
@testable import MovieQuiz

final class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)

        // When
        let exp = expectation(description: "Loading expectation")

        loader.fetchMovies { result in
            // Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                exp.fulfill()
            case .failure:
                XCTFail("Unexpected failure")
            }
        }

        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        //Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        //When
        let expectation = expectation(description: "Loading expactation")
        
        loader.fetchMovies{ result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            case .success(_):
                XCTFail("Unexpected success")
            }
        }
        waitForExpectations(timeout: 1)
    }
}

