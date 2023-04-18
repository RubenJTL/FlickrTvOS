//
//  FlickerServiceTarget.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import Foundation
import Moya

enum FlickrServiceTarget {
	case getFeedPhotos
    case searchPhotos(params: SearchParams)

    typealias SearchParams = (text: String, page: Int, perPage: Int)

    static let feedResponseFilename = "FlickrFeedResponse.json"
    static let searchResponseFilename = "FlickrSearchResponse.json"
}

extension FlickrServiceTarget: TargetType {
    var baseURL: URL {
        if let url = URL(string: "https://api.flickr.com/services") {
            return url
        } else {
            fatalError("Unable to create baseURL")
        }
    }
    var apiKey: String { "08e22f0db613f6b850daa72a94470bed" }

    var method: Moya.Method {
        switch self {
        case .getFeedPhotos, .searchPhotos:
            return .get
        }
    }

    var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

    var headers: [String: String]? {
        return nil
    }

    var parameters: [String: Any] {
        switch self {
        case .getFeedPhotos:
            return [
                "format": "json",
                "nojsoncallback": 1
            ]
        case .searchPhotos(let searchParams):
            return [
                "method": "flickr.photos.search",
                "api_key": apiKey,
                "text": searchParams.text,
                "format": "json",
                "nojsoncallback": 1,
                "page": searchParams.page,
                "per_page": searchParams.perPage,
                "extras": "date_upload, owner_name, url_z, dim_z"
            ]
        }
    }

    var path: String {
        switch self {
        case .getFeedPhotos:
            return "/feeds/photos_public.gne"
        case .searchPhotos:
            return "/rest/"
        }
    }

    public var sampleData: Data {
        switch self {
        case .getFeedPhotos:
            guard let url = Bundle.main.url(forResource: "FlickrFeedResponse", withExtension: "json"),
                  let data = try? Data(contentsOf: url)
            else { return Data() }

            return data
        case .searchPhotos:
            guard let url = Bundle.main.url(forResource: "FlickrSearchReponse", withExtension: "json"),
                  let data = try? Data(contentsOf: url)
            else { return Data() }

            return data
        }
    }
}
