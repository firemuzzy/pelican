//
//  TestUtils.swift
//  Slug
//
//  Created by Michael Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import Foundation
import Parse

class UserTestUtils {
  class func createTestUser(fname:String = "Michael", lname:String = "Charkin", email: String = "mcharkin+slugtest@gmail.com", password: String = "test" ) -> SlugUser {
    let user = SlugUser(firstName:fname, lastName: lname, email: email, password: password)
    
    user.parseObj.signUp()
    
    let foundParseUser = PFUser.logInWithUsername(email, password: "test")
    let foundUser = SlugUser(parseUser: foundParseUser)
    
    return foundUser
  }
  
  class func createTestUser1() -> SlugUser {
    return createTestUser(fname: "Bob", lname: "Builder", email: "mcharkin+slug_bobbuilder@gmail.com", password: "test")
  }
  
  class func createTestUser2() -> SlugUser{
    return createTestUser(fname: "Bruce", lname: "Wayne", email: "mcharkin+slug_bruce@gmail.com", password: "test")
  }
  
  class func createTestUser3() -> SlugUser{
    return createTestUser(fname: "Patrick", lname: "Star", email: "mcharkin+slug_patrick@gmail.com", password: "test")
  }
  
  class func createTestUser4() -> SlugUser {
    return createTestUser(fname: "Horace", lname: "Slughorn", email: "mcharkin+slug_horace@gmail.com", password: "test")
  }
  
  class func createTestUser5() -> SlugUser {
    return createTestUser(fname: "Harry", lname: "Potter", email: "mcharkin+slug_horace@adobe.com", password: "test")
  }
  
//  class func createRandomUser() -> SlugUser {
//    let uuidName = NSUUID().UUIDString
//    let uuidLastName = NSUUID().UUIDString
//    let uuidEmail = NSUUID().UUIDString
//  
//    return createTestUser(fname: uuidName, lname: uuidLastName, email: "mcharkin+\(uuidEmail)@gmail.com", password: "test")
//  }
 
}

typealias RideResultBlock = (Ride?, NSError!) -> Void


let googleSeattleGeo = PFGeoPoint(latitude: 47.648706, longitude: -122.350639)
let microsoft = PFGeoPoint(latitude: 47.645677, longitude: -122.133970)
let adobe = PFGeoPoint(latitude: 47.648305, longitude: -122.348709)
let wozGeo = PFGeoPoint(latitude: 47.605716, longitude: -122.335820)
let nearWozGeo = PFGeoPoint(latitude: 47.603643, longitude: -122.334039)
let uWashingtonGeo = PFGeoPoint(latitude: 47.654436, longitude: -122.303698)

class RideTestUtils {

  

  class func randomPrettyIntervalFromNow() -> NSDate {
    let diceRoll = Int( rand()%4 ) + 1
    
    let minuteRandomness = Int( rand()%5 ) - 2
    
    let interval = (diceRoll * 15) + minuteRandomness
    
    print("dice:\(diceRoll)  minuteRand:\(minuteRandomness) interval:\(interval)")
    
    return NSTimeInterval((diceRoll * 15) + minuteRandomness).minutes.fromNow
  }

  class func createTestRide(driver:SlugUser, maxSpaces:Int = 3, from:PFGeoPoint = wozGeo, to:PFGeoPoint = googleSeattleGeo, block:RideResultBlock?) {
    let departure:NSDate = randomPrettyIntervalFromNow()
    let ride  = Ride.create(driver, maxSpaces: maxSpaces, departure: departure, from: from, to: to)
    
    ride.parseObj.saveInBackgroundWithBlock { (didSave:Bool, error:NSError!) -> Void in
      var query = PFQuery(className:"Ride")
      let foundParseRideO = query.getObjectWithId(ride.parseObj.objectId)
      
      if let foundParseRide = foundParseRideO {
        let foundRide = Ride(parseObj: foundParseRide)
        block?(foundRide, nil)
      } else {
        block?(nil, error)
      }

    }
  }
  
  class func createTestRideWoz2Adobe(driver: SlugUser) -> Ride {
    return createTestRideBlocking(driver, from: wozGeo, to: adobe)
  }
  
  class func createTestRideWoz2MS(driver: SlugUser) -> Ride {
    return createTestRideBlocking(driver, from: wozGeo, to: microsoft)
  }
  
  class func createTestRideNearWoz2MS(driver: SlugUser) -> Ride {
    return createTestRideBlocking(driver, from: nearWozGeo, to: microsoft)
  }
  
  class func createTestRideWoz2Goog(driver: SlugUser) -> Ride {
    return createTestRideBlocking(driver, from: wozGeo, to: googleSeattleGeo)
  }
  
  class func createTestRideNearWoz2Goog(driver: SlugUser) -> Ride {
    return createTestRideBlocking(driver, from: wozGeo, to: googleSeattleGeo)
  }
  
  class func createTestRideMS2Wash(driver: SlugUser) -> Ride {
    return createTestRideBlocking(driver, from: microsoft, to: uWashingtonGeo)
  }
  
  class func createTestRideBlocking(driver:SlugUser, maxSpaces:Int = 3, from:PFGeoPoint = wozGeo, to:PFGeoPoint = googleSeattleGeo) -> Ride {
    let departure:NSDate = randomPrettyIntervalFromNow()

    let ride = Ride.create(driver, maxSpaces: maxSpaces, departure: departure, from:from, to:to)
    ride.parseObj.save()
    
    var query = PFQuery(className:"Ride")
    let foundParseRide = query.getObjectWithId(ride.parseObj.objectId)
    let foundRide = Ride(parseObj: foundParseRide)
    
    return foundRide
  }
  
}