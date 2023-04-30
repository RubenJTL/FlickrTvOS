//
//  FullscreenPhotoView.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 28/04/23.
//

import SwiftUI

struct FullscreenPhotoView: View {
    @ObservedObject var viewModel: FullscreenPhotoViewModel

    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $viewModel.currentPhoto) {
                ForEach(viewModel.photos, id: \.self) { photo in
                    Button {
                    } label: {
                        asyncImage(url: photo.imageURL)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    .buttonStyle(.card)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .ignoresSafeArea()
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
        let viewModel = FullscreenPhotoViewModel(currentPhoto: FlickrPhoto(id: "test", ownerName: "Owner", title: "new photo", imageURL: URL(string: "https://live.staticflickr.com/65535/52826093159_2da8abde33_m.jpg")), photos: [FlickrPhoto(id: "test", ownerName: "Owner", title: "new photo", imageURL: URL(string: "https://live.staticflickr.com/65535/52826093159_2da8abde33_m.jpg")), FlickrPhoto(id: "test1", ownerName: "Owner", title: "new photo", imageURL: URL(string: "https://live.staticflickr.com/65535/52826093159_2da8abde33_m.jpg")), FlickrPhoto(id: "test2", ownerName: "Owner", title: "new photo", imageURL: URL(string: "https://live.staticflickr.com/65535/52826093159_2da8abde33_m.jpg"))])
        FullscreenPhotoView(viewModel: viewModel)
    }
}
