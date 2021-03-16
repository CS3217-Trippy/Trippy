//
//  UserStorage.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 15/3/21.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

final class UserStorage: ObservableObject {
    @Published var user: User?
    let collectionPath = "users"
    let store = Firestore.firestore()

    func retrieveUserFromFirestore(user: FirebaseAuth.User, username: String) {
        let userRef = store.collection(collectionPath).document(user.uid)
        guard let email = user.email else {
            return
        }

        // Checks if user already in database and retrieve
        userRef.getDocument { document, _ in
            if let document = document, document.exists {
                self.user = try? document.data(as: User.self)
            } else {
                // Create user on database
                let userModel = User(
                    id: user.uid,
                    email: email,
                    username: username,
                    followersId: [],
                    followingId: []
                )
                do {
                    try self.store.collection(self.collectionPath).document(user.uid).setData(from: userModel)
                    self.user = userModel
                } catch {
                    return
                }
            }
        }
    }

    func getFollowersList(user: User, handler: @escaping (User) -> Void) {
        user.followersId.forEach {id in
            var userModel: User?
            store.collection(collectionPath)
            .document(id)
            .getDocument { document, _ in
                if let document = document, document.exists {
                    userModel = try? document.data(as: User.self)
                    if let newUser = userModel {
                        handler(newUser)
                    }
                }
            }

        }
    }
}
