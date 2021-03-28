////
////  UserStorage.swift
////  Trippy
////
////  Created by Audrey Felicio Anwar on 15/3/21.
////
//
// import Firebase
// import FirebaseFirestore
// import FirebaseFirestoreSwift
// import Combine
//
// final class FBUserStorage: ObservableObject, UserStorage {
//    var user: Published<User?>.Publisher {
//        $userData
//    }
//    var usersList: Published<[User]>.Publisher {
//        $usersListInternal
//    }
//    var friendsList: Published<[User]>.Publisher {
//        $friendsListInternal
//    }
//    @Published var userData: User?
//    @Published var usersListInternal: [User] = []
//    @Published var friendsListInternal: [User] = []
//    let collectionPath = "users"
//    let store = Firestore.firestore()
//
//    func retrieveUserFromFirestore(user: FirebaseAuth.User, username: String) {
//        let userRef = store.collection(collectionPath).document(user.uid)
//        guard let email = user.email else {
//            return
//        }
//
//        // Checks if user already in database and retrieve
//        userRef.getDocument { document, _ in
//            if let document = document, document.exists {
//                self.userData = try? document.data(as: User.self)
//            } else {
//                // Create user on database
//                let userModel = User(
//                    id: user.uid,
//                    email: email,
//                    username: username,
//                    friendsId: []
//                )
//                do {
//                    try self.store.collection(self.collectionPath).document(user.uid).setData(from: userModel)
//                    self.userData = userModel
//                } catch {
//                    return
//                }
//            }
//        }
//    }
//
//    func updateUserData(user: User) {
//        do {
//            try store.collection(collectionPath).document(user.id).setData(from: user)
//            self.userData = user
//        } catch {
//            return
//        }
//    }
//
//    func deleteUserFromFirestore(user: User) {
//        store.collection(collectionPath).document(user.id).delete()
//    }
//
//    func getFriendsList(user: User) {
//        friendsListInternal = []
//        user.friendsId.forEach {id in
//            var userModel: User?
//            store.collection(collectionPath)
//            .document(id)
//            .getDocument { document, _ in
//                if let document = document, document.exists {
//                    userModel = try? document.data(as: User.self)
//                    if let newUser = userModel {
//                        if !self.friendsListInternal.contains(where: { $0.id == newUser.id }) {
//                            self.friendsListInternal.append(newUser)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func getUsers() {
//        usersListInternal = []
//        store.collection(collectionPath).getDocuments {documents, _ in
//            if let documents = documents {
//                 for document in documents.documents {
//                    if let user = try? document.data(as: User.self) {
//                        self.usersListInternal.append(user)
//                    }
//                 }
//             }
//        }
//    }
//
//    func addFriend(currentUser: User, user: User) {
//        if !user.friendsId.contains(currentUser.id) {
//            user.friendsId.append(currentUser.id)
//            updateUserData(user: user)
//        }
//
//        if !currentUser.friendsId.contains(user.id) {
//            currentUser.friendsId.append(user.id)
//            updateUserData(user: currentUser)
//        }
//        getFriendsList(user: currentUser)
//    }
//
//    func deleteFriend(currentUser: User, user: User) {
//        user.friendsId = user.friendsId.filter { $0 != currentUser.id }
//        updateUserData(user: user)
//        currentUser.friendsId = currentUser.friendsId.filter { $0 != user.id }
//        updateUserData(user: currentUser)
//        getFriendsList(user: currentUser)
//    }
// }
