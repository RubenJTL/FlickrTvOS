//
//  FlickrServiceMock.swift
//  FlickrTvOSTests
//
//  Created by Ruben Torres on 18/04/23.
//

import Foundation
import Combine
@testable import FlickrTvOS

class FlickrServiceMock: FlickrServiceType {
	var numberOfCalls = 0
	var searchTextPublisher = CurrentValueSubject<String?, Never>(nil)
	var getFeedPhotosCalled = false
	var searchPhotosCalled = false
	var latestSearchText: String?

	static let shared: FlickrServiceMock = FlickrServiceMock()

	private var cancellables = Set<AnyCancellable>()

	init() {
		searchTextPublisher
			.sink { [weak self] searchText in
				self?.latestSearchText = searchText
			}
			.store(in: &cancellables)
	}

	func getFeedPhotos() -> AnyPublisher<[FlickrPhoto], Error> {
		getFeedPhotosCalled = true
		return Empty().eraseToAnyPublisher()
	}

	func searchPhotos(text: String, page: Int, perPage: Int) -> AnyPublisher<FlickrPhotos, Error> {
		searchPhotosCalled = true

		let response = FlickrPhotos(page: page, pages: 2, perPage: perPage, photo: [numberOfCalls < 1 ? FlickrServiceMock.flickrPhoto : FlickrServiceMock.flickrPhoto2])
		numberOfCalls += 1
		return Just(response)
			.setFailureType(to: Error.self)
			.eraseToAnyPublisher()
	}

	static var flickrPhoto: FlickrPhoto { .init(id: "test-id", ownerName: "TestOwnerName", title: "TestTitle")}
	static var flickrPhoto2: FlickrPhoto { .init(id: "test-id-1", ownerName: "TestOwnerName", title: "TestTitle")}
}
