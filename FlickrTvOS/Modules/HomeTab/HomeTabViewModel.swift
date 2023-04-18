//
//  HomeTabViewModel.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import Foundation

class HomeTabViewModel: ObservableObject {
    @Published var activeTab: TabItem = .feed
}

extension HomeTabViewModel {
    enum TabItem: Identifiable, CaseIterable {
        case feed
        case search

        var id: Self { self }

        var label: String {
            switch self {
            case .feed:
                return "Feed"
            case .search:
                return "Search"
            }
        }
    }
}
