//
//  RestfulService.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import Combine
import Foundation
import Moya

protocol RestfulServiceType {
    func execute<T: Decodable>(target: MultiTarget) -> AnyPublisher<T, Error>
}

final class RestfulService: RestfulServiceType {

    private let provider: MoyaProvider<MultiTarget>

    init(
        provider: MoyaProvider<MultiTarget>
    ) {
        self.provider = provider
    }

    func execute<T>(target: Moya.MultiTarget) -> AnyPublisher<T, Error> where T : Decodable {
        Future<T, Error> { [weak provider] promise in
            provider?.request(target) { result in
                switch result {
                case let .success(response):
                    do {
                        let results = try JSONDecoder().decode(T.self, from: response.data)
                        promise(.success(results))
                    } catch let error {
                        promise(.failure(error))
                    }
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

}
