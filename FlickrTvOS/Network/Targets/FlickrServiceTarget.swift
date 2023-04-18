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
    case searchPhotos(text: String, page: Int, perPage: Int)
}

extension FlickrServiceTarget: TargetType {
    var baseURL: URL { URL(string: "https://api.flickr.com/services")! }
    var apiKey: String { "08e22f0db613f6b850daa72a94470bed" }

    var method: Moya.Method {
        switch self {
        case .getFeedPhotos, .searchPhotos:
            return .get
        }
    }

    var task: Task { .requestParameters(parameters: parameters, encoding: URLEncoding.default) }

    var headers: [String : String]? {
        return nil
    }

    var parameters: [String: Any] {
        switch self {
        case .getFeedPhotos:
            return [
                "format": "json",
                "nojsoncallback": 1
            ]
        case .searchPhotos(text: let text, page: let page, perPage: let perPage):
            return [
                "method": "flickr.photos.search",
                "api_key": apiKey,
                "text": text,
                "format": "json",
                "nojsoncallback": 1,
                "page": page,
                "per_page": perPage,
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
}
