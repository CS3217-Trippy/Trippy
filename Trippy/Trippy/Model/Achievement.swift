//
//  Achievement.swift
//  Trippy
//
//  Created by Audrey Felicio Anwar on 10/4/21.
//

import Foundation

class Achievement: ImageSupportedModel {
    var id: String?
    var name: String
    var description: String
    var imageURL: URL?

    init(id: String?, name: String, description: String, imageURL: URL? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
    }
}
