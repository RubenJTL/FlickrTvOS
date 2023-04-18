//
//  FlickrPublicFeedResponse.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import Foundation

struct FlickrFeedResponse: Codable {
    let items: [FlickrFeedItem]

    private enum CodingKeys: String, CodingKey {
        case items
    }
}

struct FlickrFeedItem: Codable {
    let title: String
    let link: String?
    let media: FlickrFeedMedia?
    let published: String?
    let author: String?
    let authorID: String?

    private enum CodingKeys: String, CodingKey {
        case title, link, media, published, author, authorID = "author_id"
    }
}

struct FlickrFeedMedia: Codable {
    let m: String?
    let z: String?
}
