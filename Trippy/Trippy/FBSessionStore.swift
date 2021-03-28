//
//  SessionStore.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class FBSessionStore: ObservableObject {
    private enum AuthStates {
        case SignUp, LogIn, NoUser
    }

    var didChange = PassthroughSubject<FBSessionStore, Never>()
    @Published var session: [User] = [] {
        didSet {
            self.didChange.send(self)
        }
    }
    var username = ""
    var handle: AuthStateDidChangeListenerHandle?
    var userStorage = FBImageSupportedStorage<FBUser>()
    private var cancellables: Set<AnyCancellable> = []
    private var authState: AuthStates = .NoUser

    private func translateFromFirebaseAuthToUser(user: FirebaseAuth.User) -> User {
        User(
            id: user.uid,
            email: user.email ?? "",
            username: username,
            friendsId: []
        )
    }

    func retrieveCurrentLoggedInUser() -> User? {
        if session.count != 1 {
            return nil
        }
        return session[0]
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
                case .LogIn:
                    self.userStorage.fetchWithId(id: id)
                case .NoUser:
                    print("no user")
                }
            } else {
                self.session = []
                self.username = ""
            }
        }
    }

    func signUp(email: String, password: String, username: String, handler: @escaping AuthDataResultCallback) {
        self.username = username
        self.authState = .SignUp
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }

    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        self.authState = .LogIn
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }

    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            self.authState = .NoUser
            self.session = []
            return true
        } catch {
            return false
        }
    }

    func deleteUser(handler: @escaping ((String) -> Void)) {
        guard let user = self.retrieveCurrentLoggedInUser() else {
            fatalError("User should exist prior to be deleted")
        }
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                handler(error.localizedDescription)
            } else {
                self.userStorage.remove(user)
                self.authState = .NoUser
                self.session = []
            }
        }
    }

    func updateUser(updatedUser: User) {
        do {
            try self.userStorage.update(updatedUser)
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
