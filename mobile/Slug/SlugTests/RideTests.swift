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
    PFUser.logOut()

  }
  
  
  
  func testRide() {
    let user = UserTestUtils.createTestUser()
    
    let maxSpaces = 4
    let departureDate = 20.minutes.fromNow
    
    let ride = Ride.create(user, maxSpaces: maxSpaces, departure: departureDate, from: wozGeo, to: googleSeattleGeo)

    var writeError: NSError? = nil
    
    ride.parseObj.save(&writeError)
//    ride.save(rideEnd, error: &writeError)
    XCTAssertNil(writeError)
    
    if(writeError == nil) {
      var query = PFQuery(className:"Ride")
      query.includeKey("rideEnd")
      
      let foundParseRide = query.getObjectWithId(ride.parseObj.objectId)
      let foundRide = Ride(parseObj: foundParseRide)
      
      XCTAssertEqual(foundRide.maxSpaces, maxSpaces, "maxSpaces did not match")
      XCTAssertTrue(foundRide.departure.fuzzyEquals(departureDate), "departureDates did not match")
      XCTAssertEqual(foundRide.from!, wozGeo)
      
      XCTAssertNotNil(foundRide.rideEnd)
      if let rideEnd = foundRide.rideEnd {
        XCTAssertEqual(rideEnd.to!, googleSeattleGeo)
      }
      
    }
  }
  
  func testRideToMicrosoft() {
    let user = UserTestUtils.createTestUser()
    
    let maxSpaces = 4
    let departureDate = 20.minutes.fromNow
    
    let ride = Ride.create(user, maxSpaces: maxSpaces, departure: departureDate, from: wozGeo, to: microsoft)
    
    var writeError: NSError? = nil
    
    ride.parseObj.save(&writeError)
    //    ride.save(rideEnd, error: &writeError)
    XCTAssertNil(writeError)
    
    if(writeError == nil) {
      var query = PFQuery(className:"Ride")
      query.includeKey("rideEnd")
      
      let foundParseRide = query.getObjectWithId(ride.parseObj.objectId)
      let foundRide = Ride(parseObj: foundParseRide)
      
      XCTAssertEqual(foundRide.maxSpaces, maxSpaces, "maxSpaces did not match")
      XCTAssertTrue(foundRide.departure.fuzzyEquals(departureDate), "departureDates did not match")
      XCTAssertEqual(foundRide.from!, wozGeo)
      
      XCTAssertNotNil(foundRide.rideEnd)
      if let rideEnd = foundRide.rideEnd {
        XCTAssertEqual(rideEnd.to!, microsoft)
      }
      
    }
  }
  
  func testGettingMyRide() {
    let driver = UserTestUtils.createTestUser()
    var ride: Ride! = nil
    
    let expRideCreate = expectationWithDescription("findMyRide")
    RideTestUtils.createTestRide(driver, block: { (createdRide:Ride?, error:NSError!) -> Void in
      ride = createdRide
      expRideCreate.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    let exp = expectationWithDescription("findMyRide")

    driver.findMyCurrentDrivingRideInBackground { (pfRide: PFObject!, error:NSError!) -> Void in
      let foundRide = Ride(parseObj: pfRide)
      XCTAssertEqual(ride.parseObj.objectId, foundRide.parseObj.objectId)
      XCTAssertEqual(ride.maxSpaces, foundRide.maxSpaces)
      XCTAssertEqual(ride.maxSpaces, foundRide.maxSpaces)
      XCTAssertTrue(ride.departure.fuzzyEquals(foundRide.departure), "departureDates did not match")
      XCTAssertFalse(ride.hasDeparted)
    
      XCTAssertNotNil(foundRide.rideEnd)
      if let rideEnd = foundRide.rideEnd {
        XCTAssertEqual(rideEnd.to!, googleSeattleGeo)
      }
    
      exp.fulfill()
    }
    
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
  }
  
  func testMarkingRideAsDeparted() {
    let driver = UserTestUtils.createTestUser()

    var ride: Ride! = nil
    let expRideCreate = expectationWithDescription("findMyRide")
    RideTestUtils.createTestRide(driver, block: { (createdRide:Ride?, error:NSError!) -> Void in
      ride = createdRide
      expRideCreate.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    let exp = expectationWithDescription("departMyRide")
    
    XCTAssertNotNil(ride)
    ride.markRideDepartedInBackground(driver, block: { (succeded:Bool, error:NSError!) -> Void in
      XCTAssertTrue(succeded)
      XCTAssertNil(error)
      
      exp.fulfill()
    })
    
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    
    let exp2 = expectationWithDescription("findMyRide")
    
    driver.findMyCurrentDrivingRideInBackground { (pfRide: PFObject!, error:NSError!) -> Void in
      let foundRide = Ride(parseObj: pfRide)
      XCTAssertEqual(ride.parseObj.objectId, foundRide.parseObj.objectId)
      XCTAssertEqual(ride.maxSpaces, foundRide.maxSpaces)
      XCTAssertEqual(ride.maxSpaces, foundRide.maxSpaces)
      XCTAssertTrue(ride.departure.fuzzyEquals(foundRide.departure), "departureDates did not match")
      
      XCTAssertFalse(ride.hasDeparted)
      
      exp2.fulfill()
    }
    
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
  }

  func testRiderIncrement() {
    let driver = UserTestUtils.createTestUser()

    var ride: Ride! = nil
    let expRideCreate = expectationWithDescription("findMyRide")
    RideTestUtils.createTestRide(driver, block: { (createdRide:Ride?, error:NSError!) -> Void in
      ride = createdRide
      expRideCreate.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
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
    Ride.findByIdInBackground(ride.parseObj.objectId, block: { (obj:PFObject!, error:NSError!) -> Void in
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
    Ride.findByIdInBackground(ride.parseObj.objectId, block: { (obj:PFObject!, error:NSError!) -> Void in
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
    Ride.findByIdInBackground(ride.parseObj.objectId, block: { (obj:PFObject!, error:NSError!) -> Void in
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

    var ride: Ride! = nil
    let expRideCreate = expectationWithDescription("findMyRide")
    RideTestUtils.createTestRide(driver, maxSpaces:2, block: { (createdRide:Ride?, error:NSError!) -> Void in
      ride = createdRide
      expRideCreate.fulfill()
    })
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
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
    Ride.findByIdInBackground(ride.parseObj.objectId, block: { (obj:PFObject!, error:NSError!) -> Void in
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
    Ride.findByIdInBackground(ride.parseObj.objectId, block: { (obj:PFObject!, error:NSError!) -> Void in
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
    Ride.findByIdInBackground(ride.parseObj.objectId, block: { (obj:PFObject!, error:NSError!) -> Void in
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
