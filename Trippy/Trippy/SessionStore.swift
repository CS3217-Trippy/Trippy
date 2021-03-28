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

final class SessionStore: ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: [User] = [] {
        didSet {
            self.didChange.send(self)
        }
    }
    var username = ""
    var handle: AuthStateDidChangeListenerHandle?
    var userStorage = FBImageSupportedStorage<FBUser>()
    private var cancellables: Set<AnyCancellable> = []

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
                self.userStorage.add(user, with: nil, id: user.id)
            } else {
                self.session = []
                self.username = ""
            }
        }
    }

    func signUp(email: String, password: String, username: String, handler: @escaping AuthDataResultCallback) {
        self.username = username
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }

    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }

    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = []
            return true
        } catch {
            return false
        }
    }

    func deleteUser(handler: @escaping ((String) -> Void)) {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                handler(error.localizedDescription)
            } else {
                guard let user = self.retrieveCurrentLoggedInUser() else {
                    fatalError("User should exist prior to be deleted")
                }
                self.userStorage.remove(user)
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
