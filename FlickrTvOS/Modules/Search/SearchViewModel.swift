//
//  SearchViewModel.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""

    private let flickrService: FlickrServiceType

    init(
        flickrService: FlickrServiceType = FlickrService.shared
    ) {
        self.flickrService = flickrService
    }

    func searchTextChanged(text: String) {
        flickrService.searchTextPublisher.send(text.trimmed())
    }
}
