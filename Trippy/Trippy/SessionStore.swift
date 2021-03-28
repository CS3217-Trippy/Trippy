//
//  SessionStore.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 29/3/21.
//

import Foundation

protocol SessionStore {
    func retrieveCurrentLoggedInUser() -> User

    func listen()
    
    func signUp(email: String, password: String, username: String, handler: @escaping () -> ())

    func logIn(email: String, password: String, handler: @escaping () -> ())

    func signOut() -> Bool

    func deleteUser(handler: @escaping ((String) -> Void))

    func updateUser(updatedUser: User)

    func unbind()
}
