//
//  AccountPageViewModel.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 17/3/21.
//

import SwiftUI
import Combine

final class AccountPageViewModel: ObservableObject, Identifiable {
    @Published var email = ""
    @Published var username = ""
    @Published var errorMessage = ""
    @Published var selectedImage: UIImage?
    @Published var achievementModel: AchievementModel<FBStorage<FBAchievement>>
    @Published var imageModel: ImageModel
    @Published var user: User?
    @Published var image: UIImage?
    private var userId: String?
    private var userImageId: String?

    private var session: SessionStore

    var isOwner: Bool {
        session.currentLoggedInUser?.id == userId
    }

    init(
        session: SessionStore,
        achievementModel: AchievementModel<FBStorage<FBAchievement>>,
        user: User?,
        imageModel: ImageModel
    ) {
        self.session = session
        self.achievementModel = achievementModel
        self.imageModel = imageModel
        guard let user = user else {
            return
        }
        self.userImageId = user.imageId
        self.user = user
        self.email = user.email
        self.username = user.username
        self.userId = user.id
        getImage()
    }

    private func getImage() {
        if isOwner {
            image = session.userImage
        } else if let id = userImageId {
            imageModel.fetch(ids: [id]) { images in
                if !images.isEmpty {
                    self.image = images[0]
                }
            }
        }
    }

    func updateUserData() {
        guard let oldUser = session.currentLoggedInUser else {
            fatalError("User should have logged in")
        }
        if selectedImage != nil {
            oldUser.imageId = UUID().uuidString
        }
        oldUser.username = username
        session.updateUser(updatedUser: oldUser, with: selectedImage)
    }

    func deleteUser() {
        session.deleteUser(handler: updateErrorMessage)
    }

    func updateErrorMessage(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
