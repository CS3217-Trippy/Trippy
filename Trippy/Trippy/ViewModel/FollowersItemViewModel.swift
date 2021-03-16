//
//  FollowersItemViewModel.swift
//  Trippy
//
//  Created by Fidella Widjojo on 16/03/21.
//

import Foundation

final class FollowersItemViewModel: ObservableObject, Identifiable {
    @Published var username: String

    init(username: String) {
        self.username = username
    }
}
