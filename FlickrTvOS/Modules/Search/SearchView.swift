//
//  SearchView.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import SwiftUI

struct SearchView: View {
	@StateObject var viewModel = SearchViewModel()

    var body: some View {
        EmptyView()
        .searchable(text: $viewModel.searchText)
        .onChange(of: viewModel.searchText) { newText in
            viewModel.searchTextChanged(text: newText)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
