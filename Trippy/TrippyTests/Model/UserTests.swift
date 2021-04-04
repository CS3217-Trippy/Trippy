//
//  UserTests.swift
//  TrippyTests
//
//  Created by Audrey Felicio Anwar on 21/3/21.
//

 import XCTest
 @testable import Trippy

 class UserTests: XCTestCase {
    func testInit() {
        let user = User(id: "3217", email: "trippy@3217.com", username: "Trippy", friendsId: [], levelSystemId: "123")
        XCTAssertEqual(user.id, "3217")
        XCTAssertEqual(user.email, "trippy@3217.com")
        XCTAssertEqual(user.username, "Trippy")
        XCTAssertEqual(user.friendsId, [])
    }
 }
