//
//  UserStorage.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 19/3/21.
//

import Combine
import Firebase

protocol UserStorage {
    var user: Published<User?>.Publisher { get }

    var usersList: Published<[User]>.Publisher { get }

    var friendsList: Published<[User]>.Publisher { get }

    func retrieveUserFromFirestore(user: FirebaseAuth.User, username: String)

    func updateUserData(user: User)

    func deleteUserFromFirestore(user: User)

    func getFriendsList(user: User)

    func getUsers()

    func addFriend(currentUser: User, user: User)

    func deleteFriend(currentUser: User, user: User)
}
