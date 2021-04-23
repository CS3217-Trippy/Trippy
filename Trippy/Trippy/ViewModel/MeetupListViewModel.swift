//
//  MeetupListViewModel.swift
//  Trippy
//
//  Created by Lim Chun Yong on 12/4/21.
//
import Combine
import Foundation
final class MeetupListViewModel: ObservableObject {
    private var meetupModel: MeetupModel<FBStorage<FBMeetup>>
    @Published var currentMeetupItemViewModels: [MeetupItemViewModel] = []
    @Published var pastMeetupItemViewModels: [MeetupItemViewModel] = []
    @Published var publicMeetupViewModels: [MeetupItemViewModel] = []
    private let imageModel: ImageModel
    private var cancellables: Set<AnyCancellable> = []
    private let locationModel: LocationModel<FBStorage<FBLocation>>
    var locationListViewModel: LocationListViewModel

    init(meetupModel: MeetupModel<FBStorage<FBMeetup>>, imageModel: ImageModel, locationList: LocationListViewModel) {
        let currentDate = Date()

        self.meetupModel = meetupModel
        self.imageModel = imageModel
        self.locationListViewModel = locationList
        self.locationModel = locationList.locationModel
        meetupModel.$publicMeetupItems.map { meetup in
            meetup.filter({ $0.meetupDate > currentDate }).map { meetup in
                MeetupItemViewModel(meetupItem: meetup,
                                    meetupModel: meetupModel,
                                    imageModel: imageModel,
                                    locationModel: self.locationModel)
            }
        }
        .assign(to: \.publicMeetupViewModels, on: self)
        .store(in: &cancellables)

        meetupModel.$meetupItems.map { meetup in
            meetup.filter({ $0.meetupDate > currentDate }).map { meetup in
                MeetupItemViewModel(meetupItem: meetup, meetupModel: meetupModel, imageModel: imageModel, locationModel: self.locationModel)
            }
        }
        .assign(to: \.currentMeetupItemViewModels, on: self)
        .store(in: &cancellables)

        meetupModel.$meetupItems.map { meetup in
            meetup.filter({ $0.meetupDate < currentDate }).map { meetup in
                MeetupItemViewModel(meetupItem: meetup, meetupModel: meetupModel, imageModel: imageModel, locationModel: self.locationModel)
            }
        }
        .assign(to: \.pastMeetupItemViewModels, on: self)
        .store(in: &cancellables)

        fetch()
    }

    /// Fetches list of meetups that are public or joined by the user
    func fetch() {
        meetupModel.fetchMeetups()
    }

}
