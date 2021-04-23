//
//  LocationMapViewModel.swift
//  Trippy
//
//  Created by QL on 16/3/21.
//

import Combine

class LocationMapViewModel: ObservableObject {
    @Published var locationModel: LocationModel<FBStorage<FBLocation>>
    @Published var locations: [Location] = []
    let ratingModel: RatingModel<FBStorage<FBRating>>
    let imageModel: ImageModel
    let meetupModel: MeetupModel<FBStorage<FBMeetup>>
    let bucketModel: BucketModel<FBStorage<FBBucketItem>>
    let userId: String
    private var cancellables: Set<AnyCancellable> = []

    init(locationModel: LocationModel<FBStorage<FBLocation>>, imageModel: ImageModel,
         ratingModel: RatingModel<FBStorage<FBRating>>, bucketModel: BucketModel<FBStorage<FBBucketItem>>,
         meetupModel: MeetupModel<FBStorage<FBMeetup>>, userId: String) {
        self.locationModel = locationModel
        self.imageModel = imageModel
        self.ratingModel = ratingModel
        self.meetupModel = meetupModel
        self.bucketModel = bucketModel
        self.userId = userId

        $locationModel
          .compactMap { $0.locations }
          .assign(to: \.locations, on: self)
          .store(in: &cancellables)
    }
}
