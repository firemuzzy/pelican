//
//  SlugTests.swift
//  SlugTests
//
//  Created by Michael Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit
import XCTest

class SlugTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
  func testLoadDemoData() {
    let user1 = UserTestUtils.createTestUser(fname: "Charlie", lname: "", email: "mcharkin+slug_charlie@google.com", password: "test")
    let user2 = UserTestUtils.createTestUser(fname: "Casey", lname: "", email: "mcharkin+slug_casey@microsoft.com", password: "test")
    let user3 = UserTestUtils.createTestUser(fname: "Riley", lname: "", email: "mcharkin+slug_riley@google.com", password: "test")
    let user4 = UserTestUtils.createTestUser(fname: "Sage", lname: "", email: "mcharkin+slug_sage@microsoft.com", password: "test")
    let user5 = UserTestUtils.createTestUser(fname: "Quinn", lname: "", email: "mcharkin+slug_quinn@microsoft.com", password: "test")
    let user6 = UserTestUtils.createTestUser(fname: "Horatio", lname: "", email: "mcharkin+slug_crunch@microsoft.com", password: "test")
    let user7 = UserTestUtils.createTestUser(fname: "Reese", lname: "", email: "mcharkin+slug_reese@google.com", password: "test")
    let user8 = UserTestUtils.createTestUser(fname: "Morgan", lname: "", email: "mcharkin+slug_morgan@google.com", password: "test")
    let user9 = UserTestUtils.createTestUser(fname: "Mal", lname: "", email: "mcharkin+slug_mal@gmail.com", password: "test")
    let user10 = UserTestUtils.createTestUser(fname: "Boris", lname: "", email: "mcharkin+slug_boris@adobe.com", password: "test")
    let user11 = UserTestUtils.createTestUser(fname: "Lesley", lname: "", email: "mcharkin+slug_lesley@adobe.com", password: "test")
    let user12 = UserTestUtils.createTestUser(fname: "Harry", lname: "", email: "mcharkin+slug_harry@adobe.com", password: "test")
    
    
    
    let ride1 = RideTestUtils.createTestRideNearWoz2Goog(user1)
    let ride2 = RideTestUtils.createTestRideNearWoz2MS(user2)
    let ride3 = RideTestUtils.createTestRideWoz2Goog(user3)
    let ride4 = RideTestUtils.createTestRideWoz2MS(user4)
    let ride5 = RideTestUtils.createTestRideWoz2MS(user5)
    let ride6 = RideTestUtils.createTestRideWoz2MS(user6)
    let ride7 = RideTestUtils.createTestRideWoz2Goog(user7)
    let ride8 = RideTestUtils.createTestRideWoz2Goog(user8)
    let ride9 = RideTestUtils.createTestRideWoz2MS(user9)
    let ride10 = RideTestUtils.createTestRideWoz2Adobe(user10)
    let ride11 = RideTestUtils.createTestRideWoz2Adobe(user11)
    let ride12 = RideTestUtils.createTestRideWoz2Adobe(user12)
    
  }
    
}
