//
//  FullscreenPhotoView.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 28/04/23.
//

import SwiftUI

struct FullscreenPhotoView: View {
    @Binding var selectedPhotoIndex: Int
    let photos: [FlickrPhoto]
    let onDisappear: () -> Void

    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $selectedPhotoIndex) {
                ForEach(photos.indices, id: \.self) { index in
                    Button {
                    } label: {
                        asyncImage(url: photos[index].imageURL)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    .buttonStyle(.card)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .ignoresSafeArea()
        .onDisappear(perform: onDisappear)
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

//struct FullscreenPhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = FullscreenPhotoViewModel(currentPhoto: FlickrPhoto(id: "test", ownerName: "Owner", title: "new photo", imageURL: URL(string: "https://live.staticflickr.com/65535/52826093159_2da8abde33_m.jpg")), photos: [FlickrPhoto(id: "test", ownerName: "Owner", title: "new photo", imageURL: URL(string: "https://live.staticflickr.com/65535/52826093159_2da8abde33_m.jpg")), FlickrPhoto(id: "test1", ownerName: "Owner", title: "new photo", imageURL: URL(string: "https://live.staticflickr.com/65535/52826093159_2da8abde33_m.jpg")), FlickrPhoto(id: "test2", ownerName: "Owner", title: "new photo", imageURL: URL(string: "https://live.staticflickr.com/65535/52826093159_2da8abde33_m.jpg"))], updateCurrentPhoto: { _ in })
//        FullscreenPhotoView(viewModel: viewModel)
//    }
//}

public struct LazyView<LazyContent: View>: View {
    @ViewBuilder private var build: () -> LazyContent

    public var body: some View {
        build()
    }

    public init(@ViewBuilder build: @escaping () -> LazyContent) {
        self.build = build
    }
}
