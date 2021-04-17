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
        let user = User(
            id: "3217",
            email: "3217@gmail.com",
            username: "3217Trippy",
            friendsId: [],
            levelSystemId: "3217Level",
            achievements: [],
            imageId: nil
        )
        XCTAssertEqual(user.id, "3217")
        XCTAssertEqual(user.email, "3217@gmail.com")
        XCTAssertEqual(user.username, "3217Trippy")
        XCTAssertEqual(user.friendsId, [])
        XCTAssertEqual(user.levelSystemId, "3217Level")
        XCTAssertEqual(user.achievements, [])
        XCTAssertNil(user.imageId)
    }
 }
