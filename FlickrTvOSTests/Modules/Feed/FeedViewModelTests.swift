//
//  FeedViewModelTests.swift
//  FlickrTvOSTests
//
//  Created by Ruben Torres on 18/04/23.
//

import XCTest
import Combine
@testable import FlickrTvOS

final class FeedViewModelTests: XCTestCase {
	var cancellable: AnyCancellable?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testLoadFeedPhotos() {
		// Given
		let flickrServiceMock = FlickrServiceMock()
		_ = FeedViewModel(flickrService: flickrServiceMock)

		// When
		// Trigger loading of feed photos by initializing the view model.

		// Then
		XCTAssertTrue(flickrServiceMock.getFeedPhotosCalled)
	}

	func testSearchPhotos() {
		// Given
		let searchText = "landscape"
		let flickrServiceMock = FlickrServiceMock()
		let viewModel = FeedViewModel(debounceDuration: 0.1, flickrService: flickrServiceMock)
		let searchPhotosExpectation = expectation(description: "Search photos")

		// When
		flickrServiceMock.searchTextPublisher.send(searchText)

		// Then
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			XCTAssertEqual(viewModel.searchText, searchText)
			XCTAssertTrue(flickrServiceMock.searchPhotosCalled)
			searchPhotosExpectation.fulfill()
		}

		waitForExpectations(timeout: 1)
	}

	func testLoadMoreSearchPhotos() {
		// Given
		let searchText = "landscape"
		let flickrServiceMock = FlickrServiceMock()
		let viewModel = FeedViewModel(pages: 3, debounceDuration: 0.1, flickrService: flickrServiceMock)
		let searchPhotosExpectation = expectation(description: "Search photos")

		// When
		flickrServiceMock.searchTextPublisher.send(searchText)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			XCTAssertEqual(viewModel.searchText, searchText)
			XCTAssertTrue(flickrServiceMock.searchPhotosCalled)
			searchPhotosExpectation.fulfill()
		}
		waitForExpectations(timeout: 1)

		viewModel.loadMoreSearchPhotos(photoID: FlickrServiceMock.flickrPhoto.id)

		// Then
		let loadMorePhotosExpectation = expectation(description: "Load more photos")
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			XCTAssertEqual(viewModel.page, 2)
			loadMorePhotosExpectation.fulfill()
		}
		waitForExpectations(timeout: 1)
	}
}
