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
    @Published var session: User? {
        didSet {
            self.didChange.send(self)
        }
    }
    var username = ""
    var handle: AuthStateDidChangeListenerHandle?
    var userStorage = UserStorage()
    private var cancellables: Set<AnyCancellable> = []

    func listen() {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                self.userStorage.$user.assign(to: \.session, on: self).store(in: &self.cancellables)
                self.userStorage.retrieveUserFromFirestore(user: user, username: self.username)
            } else {
                self.session = nil
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
            self.session = nil
            return true
        } catch {
            return false
        }
    }

    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
