//
//  FlickrTvOSApp.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 17/04/23.
//

import SwiftUI

@main
struct FlickrTvOSApp: App {
	@StateObject var navigationViewModel = NavigationViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationViewModel.path) {
                HomeTabView()
                    .environmentObject(navigationViewModel)
            }
        }
    }
}

class NavigationViewModel: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
}
