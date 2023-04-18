//
//  FlickrService.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import Foundation
import Moya
import Combine

protocol FlickrServiceType {
    var searchTextPublisher: PassthroughSubject<String?, Never> { get }
    func getFeedPhotos() -> AnyPublisher<[FlickrPhoto], Error>
    func searchPhotos(text: String, page: Int, perPage: Int) -> AnyPublisher<FlickrPhotos, Error>
}

class FlickrService: FlickrServiceType {
    private let provider: RestfulServiceType

    static var shared: FlickrServiceType = FlickrService()

    var searchTextPublisher = PassthroughSubject<String?, Never>()

    init(
        provider: RestfulServiceType = RestfulService(
            provider: MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin()]))
    ) {
        self.provider = provider
    }

    func getFeedPhotos() -> AnyPublisher<[FlickrPhoto], Error> {
        provider.execute(target: MultiTarget(FlickrServiceTarget.getFeedPhotos))
            .compactMap { (response: FlickrFeedResponse) in
                response.items.compactMap {
                    FlickrPhoto(from: $0)
                }
            }
            .eraseToAnyPublisher()
    }

    func searchPhotos(text: String, page: Int = 1, perPage: Int = 30) -> AnyPublisher<FlickrPhotos, Error> {
        provider.execute(target: MultiTarget(FlickrServiceTarget.searchPhotos(params: (text: text, page: page, perPage: perPage))))
            .compactMap { (response: FlickrPhotosSearchResponse) in response.photos }
            .eraseToAnyPublisher()
    }
}
