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
    private let imageModel: ImageModel
    private var cancellables: Set<AnyCancellable> = []

    var isEmpty: Bool {
        meetupItemViewModels.isEmpty
    }

    init(meetupModel: MeetupModel<FBStorage<FBMeetup>>, imageModel: ImageModel) {
        self.meetupModel = meetupModel
        self.imageModel = imageModel
        meetupModel.$meetupItems.map { meetupItem in
            meetupItem.map { meetup in
                MeetupItemViewModel(meetupItem: meetup, meetupModel: meetupModel, imageModel: imageModel)
            }
        }
        .assign(to: \.meetupItemViewModels, on: self)
        .store(in: &cancellables)
        fetch()
    }

    func fetch() {
        meetupModel.fetchMeetups()
    }

}
