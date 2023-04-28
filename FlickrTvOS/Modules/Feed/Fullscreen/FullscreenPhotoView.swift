//
//  FullscreenPhotoView.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 28/04/23.
//

import SwiftUI

struct FullscreenPhotoView: View {
	let imageURL: URL?

    var body: some View {
        asyncImage(url: imageURL)
    }

    private func asyncImage(url: URL?) -> some View {
        AsyncImage(url: url) { phase in
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
}

struct FullscreenPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        FullscreenPhotoView(imageURL: URL(string: "https://live.staticflickr.com/65535/52826093159_2da8abde33_m.jpg"))
    }
}
