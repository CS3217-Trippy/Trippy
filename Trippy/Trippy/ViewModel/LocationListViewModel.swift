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
    @Published var recommendedLocationViewModels: [LocationCardViewModel] = []
    private var cancellables: Set<AnyCancellable> = []
    let imageModel: ImageModel

    func fetchRecommendedLocations() {
        locationModel.fetchRecommendedLocations()
    }

    init(locationModel: LocationModel<FBStorage<FBLocation>>, imageModel: ImageModel,
         ratingModel: RatingModel<FBStorage<FBRating>>, meetupModel: MeetupModel<FBStorage<FBMeetup>>,
         bucketModel: BucketModel<FBStorage<FBBucketItem>>) {
        self.locationModel = locationModel
        self.imageModel = imageModel
        self.ratingModel = ratingModel
        locationModel.$locations.map { cards in
            cards.map { location in
                LocationCardViewModel(location: location, imageModel: imageModel,
                                      ratingModel: ratingModel, bucketModel: bucketModel,
                                      meetupModel: meetupModel, userId: bucketModel.userId ?? "")
            }
        }.assign(to: \.locationCardViewModels, on: self)
        .store(in: &cancellables)

        locationModel.$recommendedLocations.map { cards in
            cards.map { location in
                LocationCardViewModel(location: location, imageModel: imageModel,
                                      ratingModel: ratingModel, bucketModel: bucketModel,
                                      meetupModel: meetupModel, userId: bucketModel.userId ?? "")
            }
        }.assign(to: \.recommendedLocationViewModels, on: self)
        .store(in: &cancellables)
    }
}
