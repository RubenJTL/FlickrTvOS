//
//  FlickrPhoto.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import Foundation

struct FlickrPhotosSearchResponse: Codable {
    let photos: FlickrPhotos
    let stat: String
}

struct FlickrPhotos: Codable {
    let page: Int
    let pages: Int
    let perPage: Int
    let photo: [FlickrPhoto]

    private enum CodingKeys: String, CodingKey {
        case page, pages, photo, perPage = "perpage"
    }
}

struct FlickrPhoto: Identifiable, Codable {
    let id: String
    let ownerName: String
    let title: String
    let height: CGFloat?
    let width: CGFloat?
    let imageURL: URL?
    let publishedDate: String?

    init(id: String, ownerName: String, title: String, height: CGFloat? = nil, width: CGFloat? = nil, imageURL: URL? = nil, publishedDate: String? = nil) {
        self.id = id
        self.ownerName = ownerName
        self.title = title
        self.height = height
        self.width = width
        self.imageURL = imageURL
        self.publishedDate = publishedDate
    }

    init?(from feedItem: FlickrFeedItem) {
        guard let link = feedItem.link, let photoURL = URL(string: link), let author = feedItem.author
        else { return nil }

        let authorString = author
        var authorName = ""
        let regex = try! NSRegularExpression(pattern: "\"(.*)\"", options: [])
        if let match = regex.firstMatch(in: authorString, options: [], range: NSRange(location: 0, length: authorString.utf16.count)) {
            let range = Range(match.range(at: 1), in: authorString)!
            authorName = String(authorString[range])
        }

        id = photoURL.lastPathComponent.replacingOccurrences(of: "/", with: "")
        ownerName = authorName
        title = feedItem.title
        height = 300
        width = 500
        imageURL = URL(string: feedItem.media?.z ?? feedItem.media?.m ?? "")
        publishedDate = feedItem.published
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, ownerName = "ownername", url = "url_z", height = "height_z", width = "width_z", dateUpload = "dateupload"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        ownerName = try container.decode(String.self, forKey: .ownerName)
        title = try container.decode(String.self, forKey: .title)
        height = try container.decodeIfPresent(CGFloat.self, forKey: .height)
        width = try container.decodeIfPresent(CGFloat.self, forKey: .width)
        imageURL = URL(string: try container.decodeIfPresent(String.self, forKey: .url) ?? "")
        publishedDate = try container.decodeIfPresent(String.self, forKey: .dateUpload)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(ownerName, forKey: .ownerName)
        try container.encode(title, forKey: .title)

        if let imageURL = imageURL {
            try container.encode(imageURL.absoluteString, forKey: .url)
        } else {
            try container.encodeNil(forKey: .url)
        }

        try container.encodeIfPresent(publishedDate, forKey: .dateUpload)
    }
}


extension FlickrPhoto {
    static var dummyData: [FlickrPhoto] {
        var dummyData = [FlickrPhoto]()
        for index in 0...6 {
			let photo = FlickrPhoto(id: "\(index)-dummyData-dummyData-title", ownerName: "dummyData", title: "dummyData-title")
            dummyData.append(photo)
        }
        return dummyData
    }
}
