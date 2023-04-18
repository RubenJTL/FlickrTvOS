//
//  FlickrPhoto.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import Foundation

struct FlickrPhotosSearchResponse: Codable {
    let photos: FlickrPhotos
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
    var height: CGFloat?
    var width: CGFloat?
    let imageURL: URL?
    var publishedDate: Date?

    static var dummyData: [FlickrPhoto] {
        var dummyData = [FlickrPhoto]()
        for index in 0...6 {
            let photo = FlickrPhoto(id: "\(index)-dummyData-dummyData-title", ownerName: "dummyData", title: "dummyData-title")
            dummyData.append(photo)
        }
        return dummyData
    }

    init(id: String, ownerName: String, title: String, height: CGFloat? = nil, width: CGFloat? = nil, imageURL: URL? = nil, publishedDate: Date? = nil) {
        self.id = id
        self.ownerName = ownerName
        self.title = title
        self.height = height
        self.width = width
        self.imageURL = imageURL
        self.publishedDate = publishedDate
    }

    init?(from feedItem: FlickrFeedItem) {
        guard let link = feedItem.link,
              let photoURL = URL(string: link),
              let authorString = feedItem.author,
              let mediaString = feedItem.media?.z ?? feedItem.media?.m
        else { return nil }

        var authorName = ""
        do {
            let regex = try NSRegularExpression(pattern: "\"(.*)\"", options: [])
            let authorRange = NSRange(authorString.startIndex..., in: authorString)
            if let match = regex.firstMatch(in: authorString, options: [], range: authorRange) {
                guard let range = Range(match.range(at: 1), in: authorString)
                else { return nil }

                authorName = String(authorString[range])
            }
        } catch {
            print("Error parsing author string: \(error.localizedDescription)")
            return nil
        }

        id = photoURL.lastPathComponent.replacingOccurrences(of: "/", with: "")
        ownerName = authorName
        title = feedItem.title
        imageURL = URL(string: mediaString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let stringDate = feedItem.published {
			publishedDate = dateFormatter.date(from: stringDate)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        ownerName = try container.decode(String.self, forKey: .ownerName)
        title = try container.decode(String.self, forKey: .title)
        height = try container.decodeIfPresent(CGFloat.self, forKey: .height)
        width = try container.decodeIfPresent(CGFloat.self, forKey: .width)
        imageURL = URL(string: try container.decodeIfPresent(String.self, forKey: .url) ?? "")

        if let dateUpload = try container.decodeIfPresent(String.self, forKey: .dateUpload), let timestamp = TimeInterval(dateUpload) {
            publishedDate = Date(timeIntervalSince1970: timestamp)
        }
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

    private enum CodingKeys: String, CodingKey {
        case id, title, ownerName = "ownername", url = "url_z", height = "height_z", width = "width_z", dateUpload = "dateupload"
    }
}
