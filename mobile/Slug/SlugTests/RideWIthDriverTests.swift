//
//  RideWIthDriverTests.swift
//  Slug
//
//  Created by Michael Charkin on 3/22/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit
import XCTest
import Parse

class RideWithDriverTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testFindingDriverSimple() {
    let user1 = UserTestUtils.createTestUser1()
    let woz2Goog = RideTestUtils.createTestRideWoz2Goog(user1)

    let nearWoz3 = PFGeoPoint(latitude: 47.605102, longitude: -122.335815)
    let nearGoog = PFGeoPoint(latitude: 47.649295, longitude: -122.350602)    
    
    let exp = expectationWithDescription("find drivers")
    Ride.findNearByDriversInBackground(nearWoz3, end: nearGoog) { (objs:[AnyObject]!, error:NSError!) -> Void in
      XCTAssertEqual(objs.count, 1)
      let parseObj = objs.first! as PFObject
      let ride = Ride(parseObj: parseObj)
      
      XCTAssertEqual(ride.from!, wozGeo)
      XCTAssertEqual(ride.rideEnd!.to!, googleSeattleGeo)
      
      exp.fulfill()
    }
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    woz2Goog.parseObj.delete()
    woz2Goog.rideEnd?.parseObj.delete()
  }

  func testFindingDriverALittleMore() {
    let user1 = UserTestUtils.createTestUser1()
    let woz2Goog = RideTestUtils.createTestRideWoz2Goog(user1)
    
    let user2 = UserTestUtils.createTestUser2()
    let woz2MS = RideTestUtils.createTestRideWoz2MS(user2)
    
    
    let nearWoz3 = PFGeoPoint(latitude: 47.605102, longitude: -122.335815)
    let nearGoog = PFGeoPoint(latitude: 47.649295, longitude: -122.350602)
    let nearMS = PFGeoPoint(latitude: 47.650003, longitude: -122.138316)
    
    let exp = expectationWithDescription("find drivers")
    Ride.findNearByDriversInBackground(nearWoz3, end: nearMS) { (objs:[AnyObject]!, error:NSError!) -> Void in
      XCTAssertEqual(objs.count, 1)
      
      if(objs.count >= 1) {
        let parseObj = objs.first! as PFObject
        let ride = Ride(parseObj: parseObj)
        
        XCTAssertEqual(ride.from!, wozGeo)
        XCTAssertEqual(ride.rideEnd!.to!, microsoft)
      }
      exp.fulfill()
    }
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
//    
    woz2Goog.parseObj.delete()
    woz2Goog.rideEnd?.parseObj.delete()
  
    woz2MS.parseObj.delete()
    woz2MS.rideEnd?.parseObj.delete()
  }

  func testFindingDriver() {
    let user1 = UserTestUtils.createTestUser1()
    let user2 = UserTestUtils.createTestUser2()
    let user3 = UserTestUtils.createTestUser3()
    let user4 = UserTestUtils.createTestUser4()
    let user5 = UserTestUtils.createTestUser5()
    
    
    let woz2Goog = RideTestUtils.createTestRideWoz2Goog(user1)
    let nearWoz2Goog = RideTestUtils.createTestRideWoz2Goog(user2)
    let woz2MS = RideTestUtils.createTestRideWoz2MS(user3)
    let nearWoz2MS = RideTestUtils.createTestRideNearWoz2MS(user4)
    let ms2Wash = RideTestUtils.createTestRideMS2Wash(user5)
    //
    
    let nearWoz3 = PFGeoPoint(latitude: 47.605102, longitude: -122.335815)
    let nearGoog = PFGeoPoint(latitude: 47.649295, longitude: -122.350602)
    let nearMS = PFGeoPoint(latitude: 47.650003, longitude: -122.138316)
    
    
    let exp = expectationWithDescription("find drivers")
    Ride.findNearByDriversInBackground(nearWoz3, end: nearGoog) { (objs:[AnyObject]!, error:NSError!) -> Void in
      XCTAssertEqual(objs.count, 2)
      
      exp.fulfill()
    }
    waitForExpectationsWithTimeout(5, { error in
      XCTAssertNil(error, "Error")
    })
    
    user1.parseObj.delete()
    user2.parseObj.delete()
    user3.parseObj.delete()
    user4.parseObj.delete()
    user5.parseObj.delete()
    
    woz2Goog.parseObj.delete()
    woz2Goog.rideEnd?.parseObj.delete()
    
    nearWoz2Goog.parseObj.delete()
    nearWoz2Goog.rideEnd?.parseObj.delete()
    
    woz2MS.parseObj.delete()
    woz2MS.rideEnd?.parseObj.delete()
    
    nearWoz2MS.parseObj.delete()
    nearWoz2MS.rideEnd?.parseObj.delete()
    
    ms2Wash.parseObj.delete()
    ms2Wash.rideEnd?.parseObj.delete()
  }

}
