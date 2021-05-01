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
            return NSLocalizedString(
                "Please select a location",
                comment: ""
            )
        case .invalidUser:
            return NSLocalizedString(
                "You are not authorized",
                comment: ""
            )
        case .invalidPrivacy:
            return NSLocalizedString(
                "Please select a privacy option",
                comment: ""
            )
        case .invalidDate:
            return NSLocalizedString(
                "Please select a date in the future",
                comment: ""
            )
        }
    }
}
