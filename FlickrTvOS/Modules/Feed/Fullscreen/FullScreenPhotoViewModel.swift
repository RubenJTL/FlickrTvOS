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

    init(currentPhoto: FlickrPhoto, photos: [FlickrPhoto]) {
        self.currentPhoto = currentPhoto
        self.photos = photos
    }
}
