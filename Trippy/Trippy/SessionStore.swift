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
    let collectionPath = "users"
    let store = Firestore.firestore()

    func listen() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.addUserToFirestore(user: user)
            } else {
                self.session = nil
            }
        }
    }

    private func addUserToFirestore(user: FirebaseAuth.User) {
        let userRef = store.collection(collectionPath).document(user.uid)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("here")
                print(document)
            } else {
                return
            }
        }
        guard let email = user.email else {
            return
        }
        let userModel = User(id: user.uid, email: email, username: username)
        do {
            try store.collection(collectionPath).document(user.uid).setData(from: userModel)
            self.session = userModel
        } catch {
            return
        }
    }

    func signUp(email: String, password: String, username: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
        self.username = username
    }

    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
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
