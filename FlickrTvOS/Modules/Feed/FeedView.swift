//
//  FeedView.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel: FeedViewModel = FeedViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large) {
                Text(viewModel.sectionTitle)
                    .padding(.horizontal, Spacing.small)
                LazyVGrid(columns: columns()) {
                    ForEach(viewModel.photos) { photo in
                        NavigationLink {
                            FullscreenPhotoView(viewModel: .init(currentPhoto: photo, photos: viewModel.photos))
                        } label: {
                            PhotoCardView(
                                imageURL: photo.imageURL,
                                title: photo.title,
                                author: photo.ownerName,
                                publishedDate: photo.publishedDate
                            )
                            .onAppear {
                                viewModel.loadMoreSearchPhotos(photoID: photo.id)
                            }
                        }
                        .buttonStyle(.card)
                    }

                    if viewModel.status.isLoading {
                        loadingSectionView
                            .focusable(false)
                    }
                }
            }
            .padding(.horizontal, Spacing.extraLarge)
        }
        .edgesIgnoringSafeArea(.horizontal)
    }

    private var loadingSectionView: some View {
        ForEach(FlickrPhoto.dummyData) {
            PhotoCardView(imageURL: $0.imageURL, title: $0.title, author: $0.ownerName, publishedDate: $0.publishedDate, isLoading: true)
        }
    }

    private func columns() -> [GridItem] {
        Array(
            repeating: .init(
                .flexible(minimum: Constants.columnMinSize, maximum: Constants.columnMaxSize),
                spacing: Spacing.huge
            ),
            count: Constants.numberOfColumns
        )
    }
}

extension FeedView {
    enum Constants {
        static let columnMaxSize: CGFloat = 580
        static let columnMinSize: CGFloat = 300
        static let numberOfColumns: Int = 3
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
