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
    @Published var usersList: [User] = []
    @Published var friendsList: [User] = []
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
                    friendsId: []
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

    func updateUserData(user: User) {
        do {
            try store.collection(collectionPath).document(user.id).setData(from: user)
            self.user = user
        } catch {
            return
        }
    }

    func deleteUserFromFirestore(user: User) {
        store.collection(collectionPath).document(user.id).delete()
    }

    func getFriendsList(user: User) {
        friendsList = []
        user.friendsId.forEach {id in
            var userModel: User?
            store.collection(collectionPath)
            .document(id)
            .getDocument { document, _ in
                if let document = document, document.exists {
                    userModel = try? document.data(as: User.self)
                    if let newUser = userModel {
                        if !self.friendsList.contains(where: { $0.id == newUser.id }) {
                            self.friendsList.append(newUser)
                        }
                    }
                }
            }

        }
    }

    func getUsers() {
        usersList = []
        store.collection(collectionPath).getDocuments {documents, _ in
            if let documents = documents {
                 for document in documents.documents {
                    if let user = try? document.data(as: User.self) {
                        self.usersList.append(user)
                    }
                 }
             }
        }
    }

    func addFriend(curUser: User, user: User) {
        if !user.friendsId.contains(curUser.id) {
            user.friendsId.append(curUser.id)
            updateUserData(user: user)
        }

        if !curUser.friendsId.contains(user.id) {
            curUser.friendsId.append(user.id)
            updateUserData(user: curUser)
        }
        getFriendsList(user: curUser)
    }

    func deleteFriend(curUser: User, user: User) {
        user.friendsId = user.friendsId.filter { $0 != curUser.id }
        updateUserData(user: user)
        curUser.friendsId = curUser.friendsId.filter { $0 != user.id }
        updateUserData(user: curUser)
        getFriendsList(user: curUser)
    }
}
