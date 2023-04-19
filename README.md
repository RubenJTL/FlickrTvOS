# FlickrTvOSApp
This is a tvOS app built using SwiftUI that allows users to search for photos on Flickr and view them in a grid layout. The app uses the Flickr API to fetch photos and displays them in a grid layout with each card containing information about the photo.

## Features
- View a grid of photos on the main page.
- Dynamically load new photos as the user scrolls down.
- Search for photos on Flickr using a search bar.
- Display search results in a grid layout.
- Show a placeholder image while loading images.
- Handle empty search results.
- Smooth scrolling with proper focus states.

## Requirements
Xcode 14.0 or later.
Swift 5.5 or later.
tvOS 16.0 or later.

## Installation
1. Clone the repository `git@github.com:RubenJTL/FlickrTvOS.git`.
2. Open `FlickrTvOS.xcodeproj` in Xcode.
3. Select the target and simulator/device you want to run the app on.
4. Add flickr api key in `FlickrServiceTarget.swift`
5. Build and run the app.

## Usage
When the app is launched, it displays a grid of photos fetched from Flickr's public feed. As the user scrolls down, new photos are dynamically loaded. The app also provides a search bar where users can enter a search term to find photos on Flickr. The search results are displayed in a new grid layout and the title of the page reflects the search term. If there are no search results, the title of the page is changed to "No search results for <search term>".

## Implementation
The main page uses a LazyVGrid with a custom View to display the photos in a grid layout, while the search page uses a SearchBar to allow users to search for photos on Flickr.

The app also utilizes the AsyncImage view from SwiftUI to display images fetched from Flickr, and a placeholder image is displayed while the image is loading.

Furthermore, the app uses the Flickr API to fetch photos and has a custom FlickrAPI class that handles the HTTP requests and parses the JSON responses. Pagination is used to fetch photos, and [Moya](https://github.com/Moya/Moya) and Combine are used to manage the request, allowing for a simpler and more organized approach to network requests.