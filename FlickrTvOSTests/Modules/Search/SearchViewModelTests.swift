//
//  SearchViewModelTests.swift
//  FlickrTvOSTests
//
//  Created by Ruben Torres on 18/04/23.
//

import XCTest
import Combine
@testable import FlickrTvOS

final class SearchViewModelTests: XCTestCase {
	var cancellable: AnyCancellable?

	override func tearDownWithError() throws {
		try super.tearDownWithError()
		cancellable?.cancel()
	}

	func testSearchTextChanged() {
		// Given
		let flickrServiceMock = FlickrServiceMock()
		let viewModel = SearchViewModel(flickrService: flickrServiceMock)
		let searchText = "landscape"
		let receivedTextExpectation = expectation(description: "Received text from searchTextPublisher")

		// When
		cancellable = flickrServiceMock.searchTextPublisher
			.dropFirst()
			.sink { receivedText in
				XCTAssertEqual(receivedText, searchText)
				receivedTextExpectation.fulfill()
			}
		viewModel.searchTextChanged(text: searchText)

		// Then
		waitForExpectations(timeout: 1)
		XCTAssertEqual(flickrServiceMock.latestSearchText, searchText)
	}

}
