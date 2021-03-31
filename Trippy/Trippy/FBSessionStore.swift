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

    var didChange = PassthroughSubject<FBSessionStore, Never>()
    var currentLoggedInUser: User?
    @Published var session: [User] = [] {
        didSet {
            self.didChange.send(self)
        }
    }
    var userStorage = FBImageSupportedStorage<FBUser>()
    @Published var levelSystemService: LevelSystemService?
    private var username = ""
    private var handle: AuthStateDidChangeListenerHandle?
    private var cancellables: Set<AnyCancellable> = []
    private var authState: AuthStates = .NoUser

    private func translateFromFirebaseAuthToUser(user: FirebaseAuth.User) -> User {
        User(
            id: user.uid,
            email: user.email ?? "",
            username: username,
            friendsId: [],
            levelSystemId: user.uid
        )
    }

    func retrieveCurrentLoggedInUser() -> User? {
        if session.count == 1 {
            currentLoggedInUser = session[0]
            return currentLoggedInUser
        }
        guard let user = currentLoggedInUser else {
            return nil
        }
        self.session = [user]
        return currentLoggedInUser
    }

    func listen() {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                self.userStorage.storedItems.assign(to: \.session, on: self).store(in: &self.cancellables)
                let user = self.translateFromFirebaseAuthToUser(user: user)
                guard let id = user.id else {
                    fatalError("User should have id generated from firebase auth")
                }
                switch self.authState {
                case .SignUp:
                    self.userStorage.add(user, with: nil, id: user.id)
                    self.levelSystemService = FBLevelSystemService(userId: id)
                    self.levelSystemService?.createLevelSystem()
                case .LogIn:
                    self.userStorage.fetchWithId(id: id)
                    self.levelSystemService = FBLevelSystemService(userId: id)
                    self.levelSystemService?.retrieveLevelSystem()
                case .NoUser:
                    print("no user")
                }
            } else {
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
            self.currentLoggedInUser = nil
            self.session = []
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    func deleteUser(handler: @escaping (String) -> Void) {
        guard let user = self.retrieveCurrentLoggedInUser() else {
            fatalError("User should exist prior to be deleted")
        }
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                handler(error.localizedDescription)
            } else {
                self.userStorage.remove(user)
                self.authState = .NoUser
                self.currentLoggedInUser = nil
                self.session = []
            }
        }
    }

    func updateUser(updatedUser: User, with image: UIImage? = nil) {
        do {
            try self.userStorage.update(updatedUser, with: image)
        } catch {
            print("Updating user failed")
        }
    }

    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
