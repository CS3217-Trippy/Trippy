//
//  MeetupError.swift
//  Trippy
//
//  Created by Lim Chun Yong on 14/4/21.
//

import Foundation

enum MeetupError: Error {
    case invalidLocation
    case invalidUser
    case invalidPrivacy
    case invalidDate
}

extension MeetupError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidLocation:
            return "Please select a location"
        case .invalidUser:
            return "You are not authorized"
        case .invalidPrivacy:
            return "Please select a privacy option"
        case .invalidDate:
            return "Please select a date in the future"
        }
    }
}
