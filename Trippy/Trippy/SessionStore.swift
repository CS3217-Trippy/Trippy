//
//  SessionStore.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 29/3/21.
//

import Foundation
import UIKit

protocol SessionStore {
    var levelSystemService: LevelSystemService? { get set }

    var session: [User] { get set }

    var currentLoggedInUser: User? { get set }

    var userStorage: FBImageSupportedStorage<FBUser> { get set }

    func listen()

    func signUp(email: String, password: String, username: String, handler: @escaping (Error?) -> Void)

    func logIn(email: String, password: String, handler: @escaping (Error?) -> Void)

    func signOut() -> Bool

    func deleteUser(handler: @escaping ((String) -> Void))

    func updateUser(updatedUser: User, with image: UIImage?)

    func unbind()
}
