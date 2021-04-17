/**
 View model of an itinerary item.
*/
import Combine
import Foundation
import UIKit

final class ItineraryItemViewModel: ObservableObject, Identifiable {
    @Published var itineraryItem: ItineraryItem
    private var itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>
    private let imageModel: ImageModel
    private(set) var id = ""
    init(
        itineraryItem: ItineraryItem,
        itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>,
        imageModel: ImageModel
    ) {
        self.itineraryItem = itineraryItem
        self.itineraryModel = itineraryModel
        self.imageModel = imageModel
        $itineraryItem.compactMap { $0.id }.assign(to: \.id, on: self)
            .store(in: &cancellables)
        fetchImage()
    }

    private func fetchImage() {
        let id = itineraryItem.locationImageId
        guard let imageId = id else {
            return
        }
        imageModel.fetch(ids: [imageId]) { images in
            if !images.isEmpty {
                self.image = images[0]
            }
        }
    }

    @Published var image: UIImage?
    private var cancellables: Set<AnyCancellable> = []
    var locationName: String {
        itineraryItem.locationName
    }

    /**
     Remove an itinerary item.
     */
    func remove() {
        itineraryModel.removeItineraryItem(itineraryItem: itineraryItem)
    }
}
