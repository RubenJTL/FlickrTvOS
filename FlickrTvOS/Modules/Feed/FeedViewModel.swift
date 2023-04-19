//
//  FeedViewModel.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import Foundation
import Combine

enum FeedViewStatus {
    case loading
    case failed
    case loaded

    var isLoading: Bool { self == .loading }
}

class FeedViewModel: ObservableObject {
    @Published private(set) var photos: [FlickrPhoto] = []
    @Published private(set) var searchText: String?
    @Published private(set) var status: FeedViewStatus = .loaded

    private let flickrService: FlickrServiceType
    private var cancellables = Set<AnyCancellable>()
	private(set) var pages: Int
	private let perPage: Int
	private let debounceDuration: TimeInterval
	private(set) var page = 1

    var sectionTitle: String {
        guard isSearching, let searchText
        else { return "Trending Now On Flickr" }

        return noResults ? "No search results for \"\(searchText)\"" : "Search Results for \"\(searchText)\""
    }

    private var isSearching: Bool {
        guard let searchText
        else { return false }

        return !searchText.isEmpty
    }
    private var noResults: Bool { !status.isLoading && photos.isEmpty }

    init(
		perPage: Int = 40,
		pages: Int = 1,
		debounceDuration: TimeInterval = 0.5,
        flickrService: FlickrServiceType = FlickrService.shared
    ) {
		self.pages = pages
		self.perPage = perPage
		self.debounceDuration = debounceDuration
        self.flickrService = flickrService

        loadPhotos()
        setupSubscriptions()
    }

    func loadMoreSearchPhotos(photoID: FlickrPhoto.ID) {
        let count = photos.count - 1
        let middleIndex = count - perPage / 2
		guard isSearching, page < pages,
			  (middleIndex > 0 && photos[middleIndex].id == photoID) || photos.last?.id == photoID
        else { return }

        page += 1

		loadPhotos()
    }

    private func setupSubscriptions() {
        flickrService.searchTextPublisher
            .debounce(for: .seconds(debounceDuration), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard let self, self.searchText != searchText
                else { return }

                self.searchText = searchText
                self.photos = []

                self.loadPhotos()
            }
            .store(in: &cancellables)
    }

    private func loadPhotos() {
        status = .loading

        guard isSearching, let searchText
        else {
            loadFeedPhotos()
            return
        }

        loadSearchPhotos(searchText: searchText)
    }

    private func loadFeedPhotos() {
        flickrService.getFeedPhotos()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.status = .loaded
                case .failure:
                    self?.status = .failed
                }
            } receiveValue: { [weak self] photos in
                self?.photos = photos
            }
            .store(in: &cancellables)
    }

    private func loadSearchPhotos(searchText: String) {
        let loadSearchPhotosPublisher = flickrService.searchPhotos(text: searchText, page: page, perPage: perPage).share()

        loadSearchPhotosPublisher
            .compactMap { $0.photo }
            .map { [weak self] photos in
                guard let self
                else { return [] }

                return photos.filter { photo in
                    !self.photos.contains(where: { $0.id == photo.id })
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.status = .loaded
                case .failure:
                    self?.status = .failed
                }
            } receiveValue: { [weak self] photos in
                self?.photos += photos
            }
            .store(in: &cancellables)

        loadSearchPhotosPublisher
            .sink { _ in } receiveValue: { [weak self] flickrPhotos in
                self?.page = flickrPhotos.page
                self?.pages = flickrPhotos.pages
            }
            .store(in: &cancellables)
    }
}
