//
//  FBSessionStore.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class FBSessionStore: ObservableObject, SessionStore {
    private enum AuthStates {
        case SignUp, LogIn, NoUser
    }

    init() {
        retrievePreviousLogInSession()
    }

    @Published var userImage: UIImage?

    var didChange = PassthroughSubject<FBSessionStore, Never>()
    @Published var currentLoggedInUser: User?
    @Published var session: [User] = [] {
        didSet {
            self.didChange.send(self)
            if session.isEmpty {
                if authState == .NoUser {
                    self.currentLoggedInUser = nil
                }
            } else if session.count == 1 {
                if let user = currentLoggedInUser {
                    if user.id == session[0].id {
                        self.currentLoggedInUser = session[0]
                    }
                } else {
                    self.currentLoggedInUser = session[0]
                }
                self.fetchUserImage()
                self.syncFriendWithUserInfo()
            }
        }
    }
    var userStorage = FBStorage<FBUser>()
    private var friendStorage: FBStorage<FBFriend>?
    @Published var levelSystemService: LevelSystemService?
    @Published var achievementService: AchievementService?
    private var username = ""
    private var handle: AuthStateDidChangeListenerHandle?
    private var cancellables: Set<AnyCancellable> = []
    private var authState: AuthStates = .NoUser

    func fetchUserImage() {
        guard let user = currentLoggedInUser, let id = user.imageId else {
            return
        }
        let model = ImageModel(storage: FBImageStorage())
        model.fetch(ids: [id]) { images in
            if !images.isEmpty {
                self.userImage = images[0]
            }
        }
    }

    func retrievePreviousLogInSession() {
        if let user = Auth.auth().currentUser {
            self.authState = .LogIn
            let modelUser = self.translateFromFirebaseAuthToUser(user: user)
            prepareInformationAfterSuccessfulLogIn(user: modelUser)
        }
    }

    private func prepareInformationAfterSuccessfulLogIn(user: User) {
        guard let id = user.id else {
            fatalError("User should have id generated from firebase auth")
        }
        let achievementService = FBAchievementService()
        self.userStorage.fetchWithId(id: id, handler: nil)
        self.friendStorage = FBStorage<FBFriend>()
        self.achievementService = achievementService
        self.levelSystemService = FBLevelSystemService(userId: id, achievementService: achievementService)
        self.levelSystemService?.retrieveLevelSystem()
    }

    private func prepareInformationAfterSuccessfulSignUp(user: User) {
        guard let id = user.id else {
            fatalError("User should have id generated from firebase auth")
        }
        let achievementService = FBAchievementService()
        self.userStorage.fetchWithId(id: id, handler: nil)
        self.userStorage.add(item: user)
        self.friendStorage = FBStorage<FBFriend>()
        self.levelSystemService = FBLevelSystemService(userId: id, achievementService: achievementService)
        self.levelSystemService?.createLevelSystem(userId: id)
        self.achievementService = FBAchievementService()
    }

    private func translateFromFirebaseAuthToUser(user: FirebaseAuth.User) -> User {
        User(
            id: user.uid,
            email: user.email ?? "",
            username: username,
            friendsId: [],
            levelSystemId: user.uid,
            achievements: [],
            imageId: nil
        )
    }

    func listen() {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                self.userStorage.storedItems.assign(to: \.session, on: self).store(in: &self.cancellables)
                let user = self.translateFromFirebaseAuthToUser(user: user)
                switch self.authState {
                case .SignUp:
                    self.prepareInformationAfterSuccessfulSignUp(user: user)
                case .LogIn:
                    self.prepareInformationAfterSuccessfulLogIn(user: user)
                case .NoUser:
                    self.userStorage.removeStoredItems()
                    print("no user")
                }
            } else {
                self.userStorage.removeStoredItems()
                self.session = []
                self.username = ""
            }
        }
    }

    func signUp(email: String, password: String, username: String, handler: @escaping (Error?) -> Void) {
        self.username = username
        self.authState = .SignUp
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            handler(error)
        }
    }

    func logIn(email: String, password: String, handler: @escaping (Error?) -> Void) {
        self.authState = .LogIn
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            handler(error)
        }
    }

    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            self.authState = .NoUser
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    func deleteUser(handler: @escaping (String) -> Void) {
        guard let user = self.currentLoggedInUser else {
            fatalError("User should exist prior to be deleted")
        }
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                handler(error.localizedDescription)
            } else {
                self.userStorage.remove(item: user)
                self.authState = .NoUser
            }
        }
    }

    func updateUser(updatedUser: User, with image: UIImage? = nil) {
        do {
            if let id = updatedUser.imageId, let image = image {
                let trippyImage = TrippyImage(id: id, image: image)
                let model = ImageModel(storage: FBImageStorage())
                model.add(with: [trippyImage])
            }
            try self.userStorage.update(item: updatedUser, handler: nil)
        } catch {
            print("Updating user failed")
        }
    }

    private func syncFriendWithUserInfo() {
        guard let user = currentLoggedInUser else {
            fatalError("User should have logged in")
        }
        guard let id = user.id else {
            fatalError("User should have id")
        }
        friendStorage?.fetchWithFieldOnce(field: "userId", value: id) { friends in
            for friend in friends {
                friend.username = user.username
                friend.userProfilePhoto = user.imageId
                do {
                    try self.friendStorage?.update(item: friend, handler: nil)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        friendStorage?.fetchWithFieldOnce(field: "friendId", value: id) { friendList in
            for associatedFriend in friendList {
                associatedFriend.friendUsername = user.username
                associatedFriend.friendProfilePhoto = user.imageId
                do {
                    try self.friendStorage?.update(item: associatedFriend, handler: nil)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
