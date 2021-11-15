//
//  SearchScreenViewModelTests.swift
//  SapChallengeTests
//
//  Created by Svilen Kirov on 15.11.21.
//

import XCTest
@testable import SapChallenge

private let imageData = [ImageData(id: "0", farm: 0, server: "0", secret: "0")]

class SearchScreenViewModelTests: XCTestCase {
    
    var viewModel: SearchScreenViewModel!
    fileprivate var service: MockRepositoryService!
    fileprivate var tracker: MockHistoryTracker!
    fileprivate static var currentExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        service = MockRepositoryService()
        tracker = MockHistoryTracker()
        viewModel = SearchScreenViewModel(repository: service, historyTracker: tracker)
        viewModel.searchBy(term: "Hawai")
    }
    
    override func tearDown() {
        SearchScreenViewModelTests.currentExpectation = nil
        self.viewModel = nil
        self.tracker = nil
        self.service = nil
        super.tearDown()
    }

    func testSearchForTerm() throws {
        SearchScreenViewModelTests.currentExpectation = self.expectation(description: "Searching")
        viewModel.searchBy(term: "Hawai")
        XCTAssertEqual(viewModel.term, "Hawai", "Expected Hawai as a Term")
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.currentPage, 0, "Expected current page to be 0.")
        XCTAssertEqual(viewModel.maxPages, 10, "Expected to have 10 as max pages.")
        XCTAssertEqual(viewModel.imagesCount, 1, "Expected to have 1 images.")
        XCTAssertEqual(viewModel.isLoading.value, false, "Expected to have stopped loading.")
    }
    
    // Term property should remain consistent
    func testSearchForNoImagesTerm() throws {
        viewModel.searchBy(term: "jsakldjskaldlksajkdjklsajkdlsajkldjlksajdkl")
        XCTAssertEqual(viewModel.term, "jsakldjskaldlksajkdjklsajkdlsajkldjlksajdkl", "Expected jsakldjskaldlksajkdjklsajkdlsajkldjlksajdkl as a Term")
    }
    
    func testGetImageDataWithinRange() throws {
        viewModel.imageData.value = imageData
        if viewModel.getImageData(for: 0) == nil {
            XCTAssert(false, "ViewModel should be able give imageData within range")
        }
    }
    
    func testGetImageDataExceedsRange() throws {
        viewModel.imageData.value = imageData
        if viewModel.getImageData(for: 1) != nil {
            XCTAssert(false, "ViewModel should not be able give imageData outside of range")
        }
    }
    
    func testLoadNextPage() throws {
        SearchScreenViewModelTests.currentExpectation = self.expectation(description: "Downloading Page")
        viewModel.loadNextPage()
        XCTAssertEqual(viewModel.currentPage, 1, "Expected to be at page 1")
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertEqual(viewModel.imageData.value?.count, 2, "Expected to have 2 imageDatas")
    }
    
    func testLoadNextPageMaxPage() throws {
        viewModel.currentPage = viewModel.maxPages
        let currentPage = viewModel.currentPage
        viewModel.loadNextPage()
        XCTAssertEqual(viewModel.currentPage, currentPage, "Expected to not change pages after being at the final one.")
        XCTAssertEqual(viewModel.imageData.value?.count, 1, "Expected to have 1 imageData")
    }
}

private class MockRepositoryService: RepositoryProtocol {
    
    func getImages(byTerm term: String, completion: @escaping (ImageDataContainer?) -> Void) {
        completion(ImageDataContainer(page: 0, pages: 10, photo: imageData))
        SearchScreenViewModelTests.currentExpectation?.fulfill()
    }
    
    func getPageFor(term: String, _ pageNumber: Int, completion: @escaping ([ImageData]?) -> Void) {
        completion(imageData)
        SearchScreenViewModelTests.currentExpectation?.fulfill()
    }
    
    func downloadImage(from data: ImageData, completion: @escaping (Data?) -> Void) {
        
    }
}

private class MockHistoryTracker: HistoryTrackerProtocol {
    
    private var terms: [String] = ["abra", "cadabra"]
    
    func addToHistory(term: String) {
        terms.append(term)
    }
    
    func clearHistory() {
        terms = []
    }
    
    func getHistory() -> [String] {
        terms
    }
}
