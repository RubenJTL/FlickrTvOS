//
//  FullScreenPhotoViewModel.swift
//  FlickrTvOS
//
//  Created by Ruben Torres on 28/04/23.
//

import Foundation
import SwiftUI

final class FullscreenPhotoViewModel: ObservableObject {
    @Published var currentPhoto: FlickrPhoto
    let photos: [FlickrPhoto]

//    let updateCurrentPhoto: (FlickrPhoto) -> Void

    init(currentPhoto: FlickrPhoto, photos: [FlickrPhoto], updateCurrentPhoto: @escaping (FlickrPhoto) -> Void) {
        self.currentPhoto = currentPhoto
        self.photos = photos
//        self.updateCurrentPhoto = updateCurrentPhoto
    }
}
