//
//  RideTests.swift
//  Slug
//
//  Created by Michael Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit
import XCTest
import Parse

class RideTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testRiderIncrement() {
    let driver = UserTestUtils.createTestUser()
    let ride = RideTestUtils.createTestRide(driver)
    
    let slug1 = UserTestUtils.createTestUser1()
    let expSlug1Grab = expectationWithDescription("slug1")
    ride.grabASpotInBackground(slug1, block: { (didGrab:Bool, error:NSError!) -> Void in
      XCTAssertTrue(didGrab)
      XCTAssertNil(error)
      expSlug1Grab.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    
    let expSlug1GrabFind = expectationWithDescription("slug1Find")
    Ride.findByIdBackground(ride.parseObj.objectId, block: { (obj:PFObject!, error:NSError!) -> Void in
      let foundRide = Ride(parseObj: obj)
      XCTAssertTrue(foundRide.hasSpots())
      XCTAssertEqual(foundRide.riderIds.count, 1, "wrong rider count")
      
      expSlug1GrabFind.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    
    
    let slug2 = UserTestUtils.createTestUser2()
    let expSlug2Grab = expectationWithDescription("slug2")
    ride.grabASpotInBackground(slug2, block: { (didGrab:Bool, error:NSError!) -> Void in
      XCTAssertTrue(didGrab)
      XCTAssertNil(error)
      expSlug2Grab.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    let expSlug2GrabFind = expectationWithDescription("slug2Find")
    Ride.findByIdBackground(ride.parseObj.objectId, block: { (obj:PFObject!, error:NSError!) -> Void in
      let foundRide = Ride(parseObj: obj)
      XCTAssertTrue(foundRide.hasSpots())
      XCTAssertEqual(foundRide.riderIds.count, 2, "wrong rider count")
      
      expSlug2GrabFind.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    
    
    let slug3 = UserTestUtils.createTestUser3()
    let expSlug3Grab = expectationWithDescription("slug3")
    ride.grabASpotInBackground(slug3, block: { (didGrab:Bool, error:NSError!) -> Void in
      XCTAssertTrue(didGrab)
      XCTAssertNil(error)
      expSlug3Grab.fulfill()
    })
    
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    let expSlug3GrabFind = expectationWithDescription("slug3Find")
    Ride.findByIdBackground(ride.parseObj.objectId, block: { (obj:PFObject!, error:NSError!) -> Void in
      let foundRide = Ride(parseObj: obj)
      XCTAssertFalse(foundRide.hasSpots())
      XCTAssertEqual(foundRide.riderIds.count, 3, "wrong rider count")
      
      expSlug3GrabFind.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
  }

  func testRiderMaxOut() {
    let driver = UserTestUtils.createTestUser()
    let ride = RideTestUtils.createTestRide(driver, maxSpaces: 2)
    
    let slug1 = UserTestUtils.createTestUser1()
    let expSlug1Grab = expectationWithDescription("slug1")
    ride.grabASpotInBackground(slug1, block: { (didGrab:Bool, error:NSError!) -> Void in
      XCTAssertTrue(didGrab)
      XCTAssertNil(error)
      expSlug1Grab.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    
    let expSlug1GrabFind = expectationWithDescription("slug1Find")
    Ride.findByIdBackground(ride.parseObj.objectId, block: { (obj:PFObject!, error:NSError!) -> Void in
      let foundRide = Ride(parseObj: obj)
      XCTAssertTrue(foundRide.hasSpots())
      XCTAssertEqual(foundRide.riderIds.count, 1, "wrong rider count")
      
      expSlug1GrabFind.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    
    
    let slug2 = UserTestUtils.createTestUser2()
    let expSlug2Grab = expectationWithDescription("slug2")
    ride.grabASpotInBackground(slug2, block: { (didGrab:Bool, error:NSError!) -> Void in
      XCTAssertTrue(didGrab)
      XCTAssertNil(error)
      expSlug2Grab.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    let expSlug2GrabFind = expectationWithDescription("slug2Find")
    Ride.findByIdBackground(ride.parseObj.objectId, block: { (obj:PFObject!, error:NSError!) -> Void in
      let foundRide = Ride(parseObj: obj)
      XCTAssertFalse(foundRide.hasSpots())
      XCTAssertEqual(foundRide.riderIds.count, 2, "wrong rider count")
      
      expSlug2GrabFind.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })

    
    
    let slug3 = UserTestUtils.createTestUser3()
    let expSlug3Grab = expectationWithDescription("slug3")
    ride.grabASpotInBackground(slug3, block: { (didGrab:Bool, error:NSError!) -> Void in
      XCTAssertFalse(didGrab)
      XCTAssertNotNil(error)
      expSlug3Grab.fulfill()
    })
    
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    let expSlug3GrabFind = expectationWithDescription("slug3Find")
    Ride.findByIdBackground(ride.parseObj.objectId, block: { (obj:PFObject!, error:NSError!) -> Void in
      let foundRide = Ride(parseObj: obj)
      XCTAssertFalse(foundRide.hasSpots())
      XCTAssertEqual(foundRide.riderIds.count, 2, "wrong rider count")
      
      expSlug3GrabFind.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
  }


}
