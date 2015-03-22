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
    let user = SlugUser(firstName:"Michael", lastName: "Charkin", email: email, password: password)
    
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
 
}

typealias RideResultBlock = (Ride?, NSError!) -> Void


let googleSeattleGeo = PFGeoPoint(latitude: 47.648706, longitude: -122.350639)
let microsoft = PFGeoPoint(latitude: 47.645677, longitude: -122.133970)
let wozGeo = PFGeoPoint(latitude: 47.605716, longitude: -122.335820)

class RideTestUtils {
  class func createTestRide(driver:SlugUser, maxSpaces:Int = 3, departure:NSDate = 20.minutes.fromNow, from:PFGeoPoint = wozGeo, to:PFGeoPoint = googleSeattleGeo, block:RideResultBlock?) {
    let ride = Ride(driver: driver, maxSpaces: maxSpaces, departure: departure, from: from, to: to)
    ride.parseObj.saveInBackgroundWithBlock { (didSave:Bool, error:NSError!) -> Void in
      var query = PFQuery(className:"Ride")
      let foundParseRideO = query.getObjectWithId(ride.parseObj.objectId)

      if let foundParseRide = foundParseRideO {
        let foundRide = Ride(parseObj: foundParseRide)
        block?(foundRide, nil)
      } else {
        block?(nil, NSError.withMsg("error"))
      }
    }
  }
  
  class func createTestRideBlocking(driver:SlugUser, maxSpaces:Int = 3, departure:NSDate = 20.minutes.fromNow, from:PFGeoPoint = wozGeo, to:PFGeoPoint = googleSeattleGeo) -> Ride {
    let ride = Ride(driver: driver, maxSpaces: maxSpaces, departure: departure, from:from, to:to)
    ride.parseObj.save()
    
    var query = PFQuery(className:"Ride")
    let foundParseRide = query.getObjectWithId(ride.parseObj.objectId)
    let foundRide = Ride(parseObj: foundParseRide)
    
    return foundRide
  }
  
}