//
//  LocationListViewModel.swift
//  Trippy
//
//  Created by QL on 13/3/21.
//

import Combine

class LocationListViewModel: ObservableObject {
    @Published var locationModel: LocationModel<FBStorage<FBLocation>>
    @Published var ratingModel: RatingModel<FBStorage<FBRating>>
    @Published var locationCardViewModels: [LocationCardViewModel] = []
    @Published var locationDetailViewModels: [LocationDetailViewModel] = []
    @Published var recommendedLocationViewModels: [LocationCardViewModel] = []
    var meetupModel: MeetupModel<FBStorage<FBMeetup>>
    var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    var itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>
    var userId: String?
    private var cancellables: Set<AnyCancellable> = []
    let imageModel: ImageModel

    func fetchRecommendedLocations() {
        locationModel.fetchRecommendedLocations()
    }

    func getDetailViewModel(locationId: String) -> LocationDetailViewModel? {
        locationDetailViewModels.first {
            $0.location.id == locationId
        }
    }

    init(locationModel: LocationModel<FBStorage<FBLocation>>, imageModel: ImageModel,
         ratingModel: RatingModel<FBStorage<FBRating>>, meetupModel: MeetupModel<FBStorage<FBMeetup>>,
         bucketModel: BucketModel<FBStorage<FBBucketItem>>,
         itineraryModel: ItineraryModel<FBStorage<FBItineraryItem>>, userId: String?) {
        self.locationModel = locationModel
        self.imageModel = imageModel
        self.ratingModel = ratingModel
        self.bucketModel = bucketModel
        self.meetupModel = meetupModel
        self.itineraryModel = itineraryModel
        self.userId = userId
        locationModel.$locations.map { cards in
            cards.map { location in
                LocationCardViewModel(location: location, imageModel: imageModel,
                                      ratingModel: ratingModel, bucketModel: bucketModel,
                                      meetupModel: meetupModel, userId: bucketModel.userId ?? "",
                                      locationModel: locationModel, itineraryModel: itineraryModel)
            }
        }.assign(to: \.locationCardViewModels, on: self)
        .store(in: &cancellables)

        locationModel.$locations.map { cards in
            cards.map { location in
                LocationDetailViewModel(
                    location: location, imageModel: imageModel,
                    ratingModel: ratingModel, bucketModel: bucketModel,
                    meetupModel: meetupModel, locationModel: locationModel,
                    itineraryModel: itineraryModel, userId: bucketModel.userId ?? "")
            }
        }.assign(to: \.locationDetailViewModels, on: self)
        .store(in: &cancellables)

        locationModel.$recommendedLocations.map { cards in
            cards.map { location in
                LocationCardViewModel(location: location, imageModel: imageModel,
                                      ratingModel: ratingModel, bucketModel: bucketModel,
                                      meetupModel: meetupModel, userId: bucketModel.userId ?? "",
                                      locationModel: locationModel, itineraryModel: itineraryModel)
            }
        }.assign(to: \.recommendedLocationViewModels, on: self)
        .store(in: &cancellables)
    }
}
