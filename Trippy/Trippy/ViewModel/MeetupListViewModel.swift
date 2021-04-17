//
//  MeetupListViewModel.swift
//  Trippy
//
//  Created by Lim Chun Yong on 12/4/21.
//
import Combine

final class MeetupListViewModel: ObservableObject {
    private var meetupModel: MeetupModel<FBStorage<FBMeetup>>
    @Published var meetupItemViewModels: [MeetupItemViewModel] = []
    @Published var publicMeetupViewModels: [MeetupItemViewModel] = []
    private let imageModel: ImageModel
    private var cancellables: Set<AnyCancellable> = []

    var hasNoMeetups: Bool {
        meetupItemViewModels.isEmpty
    }

    init(meetupModel: MeetupModel<FBStorage<FBMeetup>>, imageModel: ImageModel) {
        self.meetupModel = meetupModel
        self.imageModel = imageModel
        meetupModel.$publicMeetupItems.map { meetupItem in
            meetupItem.map { meetup in
                MeetupItemViewModel(meetupItem: meetup, meetupModel: meetupModel, imageModel: imageModel)
            }
        }
        .assign(to: \.publicMeetupViewModels, on: self)
        .store(in: &cancellables)
        meetupModel.$meetupItems.map { meetupItem in
            meetupItem.map { meetup in
                MeetupItemViewModel(meetupItem: meetup, meetupModel: meetupModel, imageModel: imageModel)
            }
        }
        .assign(to: \.meetupItemViewModels, on: self)
        .store(in: &cancellables)
        fetch()
    }

    /// Fetches list of meetups that are public or joined by the user
    func fetch() {
        meetupModel.fetchMeetups()
    }

}
