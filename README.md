# Image Gallery
Xcode 15.4, Swift 5.6, iOS 18.0

## UI:
2 Tab include:
- Gallery: Show a list of downloaded images thumbnail. When the user press on an image, the detail view will present.
- Favourite: Show a list of favourite-marked images. When the user press on an image, the detail view will present.

Detail view show the actual images, there is a button on tool bar to toggle favourite.

## Architecture:
Use MVVM architecture, the system is seperated into 4 main layers:
- View layer: GalleryView, DetailView, FavouriteView
- ViewModel layer: GalleryViewModel, FavouriteViewModel
- RepositoryLayer: ImageRepository (this class connect the data layer components with the view model layer components)
- Data layer: ImageEntity, ImageDownloader, FavouriteImageStore

## Techstack:
SwiftUI, SwiftData, Concurrency, XCTest

## Additional library
- swiftui-cached-async-image (https://github.com/apple/swift-docc-plugin): for the usage of caching `AsyncImage`.
