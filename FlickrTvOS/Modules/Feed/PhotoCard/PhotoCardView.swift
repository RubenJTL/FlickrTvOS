//
//  PhotoCard.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import SwiftUI

struct PhotoCardView: View {
    let imageURL: URL?
    let title: String
    let author: String
    let publishedDate: Date?
    var isLoading: Bool = false

    var body: some View {
        Button(action: {}, label: {
            asyncImage()
                .overlay(alignment: .bottom) {
                    gradientView
                }
                .overlay(alignment: .bottomLeading) {
                    labelsView
                }
        })
        .buttonStyle(.card)
    }

    private var authorPublishedDateLabel: String {
        guard let publishedDate
        else { return author }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        let formattedDate = dateFormatter.string(from: publishedDate)

        return "\(author) / \(formattedDate)"
    }

    private var emptyImageView: some View {
        ZStack {
            Color.gray
            ProgressView()
        }
    }

    private var failureImageView: some View {
        ZStack {
            Color.gray
            Image(systemName: "photo.tv")
        }
    }

    private var labelsView: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text(title)
            Text(authorPublishedDateLabel)
        }
        .lineLimit(2)
        .multilineTextAlignment(.leading)
        .padding(Spacing.regular)
        .redacted(reason: isLoading ? .placeholder : [])
    }

    private var gradientView: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .clear, location: 0.6),
                .init(color: .black.opacity(0.7), location: 0.9),
                .init(color: .black, location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    @ViewBuilder
    private func asyncImage() -> some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                emptyImageView
            case .failure:
                failureImageView
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()

            @unknown default:
                fatalError("Unexpected phase state was returned")
            }
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .frame(maxWidth: Constants.imageSize.width)
        .frame(height: Constants.imageSize.height)
    }
}

extension PhotoCardView {
    enum Constants {
        static let imageSize: CGSize = .init(width: 600, height: 300)
    }
}

struct PhotoCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PhotoCardView(imageURL: URL(string: "https://live.staticflickr.com/65535/52826093159_2da8abde33_m.jpg"), title: "Game", author: "jnn1776", publishedDate: Date(), isLoading: true)
            PhotoCardView(imageURL: URL(string: "https://live.staticflickr.com/65535/52826093159_2da8abde33_m.jpg"), title: "Game", author: "jnn1776", publishedDate: Date(), isLoading: false)
        }
    }
}
