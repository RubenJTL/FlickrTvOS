//
//  HomeTabView.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import SwiftUI

struct HomeTabView: View {
    @StateObject var viewModel = HomeTabViewModel()

    var body: some View {
        TabView(selection: $viewModel.activeTab) {
            ForEach(HomeTabViewModel.TabItem.allCases) { item in
                view(for: item)
                    .tabItem { itemLabel(for: item) }
                    .tag(item)
            }
        }
        .background(Color.black.ignoresSafeArea())
    }

    private func itemLabel(for tabItem: HomeTabViewModel.TabItem) -> some View {
        Text(tabItem.label)
    }

    @ViewBuilder
    private func view(for tabItem: HomeTabViewModel.TabItem) -> some View {
        switch tabItem {
        case .feed:
            FeedView()
        case .search:
			SearchView()
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
