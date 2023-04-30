//
//  FeedView.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import SwiftUI

enum Focusable: Hashable {
    case none
    case row(id: String)
}

struct FeedView: View {
    @StateObject var viewModel: FeedViewModel = FeedViewModel()
    @FocusState var focusedReminder: Focusable?
    @EnvironmentObject var navigationViewModel: NavigationViewModel

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.large) {
                    Text(viewModel.sectionTitle)
                        .padding(.horizontal, Spacing.small)
                    LazyVGrid(columns: columns()) {
                        ForEach(viewModel.photos.indices, id: \.self) { index in
                            let photo = viewModel.photos[index]
                            Button {
                                viewModel.select(photo: photo)
                                navigationViewModel.path.append(photo)
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
                            .focused($focusedReminder, equals: .row(id: photo.id))
                        }
                        if viewModel.status.isLoading {
                            loadingSectionView
                                .focusable(false)
                        }
                    }
                }
                .padding(.horizontal, Spacing.extraLarge)
            }
            .navigationDestination(for: FlickrPhoto.self) { _ in
                FullscreenPhotoView(selectedPhotoIndex: $viewModel.currentPhotoIndex, photos: viewModel.photos, onDisappear: {
                    focusedReminder = .row(id: viewModel.photos[viewModel.currentPhotoIndex].id)
                    scrollProxy.scrollTo(viewModel.currentPhotoIndex)
                })
            }
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
