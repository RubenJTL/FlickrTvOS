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
    let dayPublished: String
    var isLoading: Bool = false

    var body: some View {
        Button(action: {}) {
            asyncImage
                .overlay(alignment: .bottom) {
                    gradientView
                }
                .overlay(alignment: .bottomLeading) {
                    labels
                }
        }
        .buttonStyle(.card)
    }

    @ViewBuilder
    private var asyncImage: some View {
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
                fatalError()
            }
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .frame(maxWidth: Constants.imageSize.width)
        .frame(height: Constants.imageSize.height)
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

    private var labels: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text(title)
            Text(author)+Text(dayPublished)
        }
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
}

extension PhotoCardView {
    enum Constants {
        static let imageSize: CGSize = .init(width: 500, height: 300)
    }
}

struct PhotoCard_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCardView(imageURL: URL(string: "https://live.staticflickr.com/65535/52826093159_2da8abde33_m.jpg"), title: "Game", author: "jnn1776", dayPublished: "2023-04-18T00:43:06Z", isLoading: true)
    }
}
