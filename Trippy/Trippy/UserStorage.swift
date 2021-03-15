//
//  UserStorage.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 15/3/21.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserStorage: ObservableObject {
    let collectionPath = "users"
    let store = Firestore.firestore()

    func retrieveUserFromFirestore(user: FirebaseAuth.User, username: String) -> User? {
        let userRef = store.collection(collectionPath).document(user.uid)
        guard let email = user.email else {
            return nil
        }
        var userModel: User?
        var documentExists = false

        // Checks if user already in database and retrieve
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                documentExists = true
                userModel = try? document.data(as: User.self) ?? nil
            }
        }
        if documentExists {
            return userModel
        }

        // Create new user entry in database
        userModel = User(id: user.uid, email: email, username: username)
        do {
            try store.collection(collectionPath).document(user.uid).setData(from: userModel)
            return userModel
        } catch {
            return nil
        }
    }
}
