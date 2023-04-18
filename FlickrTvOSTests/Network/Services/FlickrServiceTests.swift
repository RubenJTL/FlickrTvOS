//
//  FlickrService.swift
//  FlickrTvOSTests
//
//  Created by Ruben Torres on 18/04/23.
//

import XCTest
import Combine
import Moya
@testable import FlickrTvOS

final class FlickrServiceTests: XCTestCase {
    var service: FlickrService!
    var provider: MoyaProvider<MultiTarget>!
    var cancellable: AnyCancellable?

    override func setUpWithError() throws {
        provider = MoyaProvider<MultiTarget>(
            endpointClosure: { target in
                let method = target.method
                let sampleResponse: Endpoint.SampleResponseClosure = {
                    .networkResponse(200, target.sampleData)
                }
                return Endpoint(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: sampleResponse,
                    method: method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            },
            stubClosure: MoyaProvider.immediatelyStub
        )
        service = FlickrService(provider: RestfulService(provider: provider))
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        cancellable?.cancel()
    }

    func testGetFeedPhotos() throws {
        // Given

        // When
        let expectation = XCTestExpectation(description: "Receive feed photos")
        var photos: [FlickrPhoto]?
        cancellable = service.getFeedPhotos().sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case let .failure(error):
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            },
            receiveValue: { feedPhotos in
                photos = feedPhotos
            }
        )

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(photos)
        XCTAssertEqual(photos?.count, 2)
        XCTAssertEqual(photos?[0].title, "snapshot")
        XCTAssertEqual(photos?[0].imageURL?.absoluteString, "https://live.staticflickr.com/65535/52827101327_fe0b58f9ec_m.jpg")
        XCTAssertEqual(photos?[0].ownerName, "hasiy3")
        XCTAssertEqual(photos?[1].title, "AN5I1567.jpg")
        XCTAssertEqual(photos?[1].imageURL?.absoluteString, "https://live.staticflickr.com/65535/52827101402_79fdd16af5_m.jpg")
    }

    func testSearchPhotos() throws {
        // Given

        // When
        let expectation = XCTestExpectation(description: "Receive search photos")
        var photos: FlickrPhotos?
        cancellable = service.searchPhotos(text: "test").sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case let .failure(error):
                    XCTFail("Unexpected error: \(error.localizedDescription)")
                }
            },
            receiveValue: { value in
                photos = value
            }
        )

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(photos)
        XCTAssertEqual(photos?.photo.count, 2)
        XCTAssertEqual(photos?.photo[0].title, "Students and Senior Leaders From the North Atlantic Treaty Organization (NATO) Defense College Visit ANC")

    }

}
