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
    var meetupModel: MeetupModel<FBStorage<FBMeetup>>
    var bucketModel: BucketModel<FBStorage<FBBucketItem>>
    var userId: String?
    private var cancellables: Set<AnyCancellable> = []
    let imageModel: ImageModel

    func fetchRecommendedLocations() {
        locationModel.fetchRecommendedLocations()
    }

    init(locationModel: LocationModel<FBStorage<FBLocation>>, imageModel: ImageModel,
         ratingModel: RatingModel<FBStorage<FBRating>>, meetupModel: MeetupModel<FBStorage<FBMeetup>>,
         bucketModel: BucketModel<FBStorage<FBBucketItem>>, userId: String?) {
        self.locationModel = locationModel
        self.imageModel = imageModel
        self.ratingModel = ratingModel
        self.bucketModel = bucketModel
        self.meetupModel = meetupModel
        self.userId = userId
        locationModel.$locations.map { cards in
            cards.map { location in
                LocationCardViewModel(location: location, imageModel: imageModel,
                                      ratingModel: ratingModel, bucketModel: bucketModel,
                                      meetupModel: meetupModel, userId: bucketModel.userId ?? "", locationModel: locationModel)
            }
        }.assign(to: \.locationCardViewModels, on: self)
        .store(in: &cancellables)

        locationModel.$recommendedLocations.map { cards in
            cards.map { location in
                LocationCardViewModel(location: location, imageModel: imageModel,
                                      ratingModel: ratingModel, bucketModel: bucketModel,
                                      meetupModel: meetupModel, userId: bucketModel.userId ?? "", locationModel: locationModel)
            }
        }.assign(to: \.recommendedLocationViewModels, on: self)
        .store(in: &cancellables)
    }
}
