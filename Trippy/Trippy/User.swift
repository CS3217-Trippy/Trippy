//
//  User.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 14/3/21.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var username: String
}
