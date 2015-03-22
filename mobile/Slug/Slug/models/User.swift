//
//  User.swift
//  Slug
//
//  Created by Michael Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import Foundation
import Parse

class SlugUser {

  let parseObj:PFUser

  init(parseUser: PFUser) {
    self.parseObj = parseUser
  }
  
  init(firstName:String, lastName:String, email:String, password:String) {
    self.parseObj = PFUser()
    self.parseObj.username = email
    self.parseObj.email = email
    self.parseObj.password = password
    
    self.firstName = firstName
    self.lastName = lastName
  }

  var email: String {
    get {
      return self.parseObj.email
    }
  }

  var firstName: String {
    get {
      return self.parseObj["firstName"] as String
    }
    set {
      self.parseObj["firstName"] = newValue
    }
  }
  
  var lastName: String {
    get {
      return self.parseObj["lastName"] as String
    }
    set {
      self.parseObj["lastName"] = newValue
    }
  }
  
  var home: PFGeoPoint {
    get {
      return self.parseObj["home"] as PFGeoPoint
    }
    set {
      self.parseObj["home"] = newValue
    }
  }
  
  var work: PFGeoPoint {
    get {
      return self.parseObj["work"] as PFGeoPoint
    }
    set {
      self.parseObj["work"] = newValue
    }
  }
  
  var drivingRide: PFObject? {
    get {
      return self.parseObj["drivingRide"] as? PFObject
    }
    set {
      self.parseObj["drivingRide"] = newValue
    }
  }
  
  func findMyCurrentDrivingRideInBackground(block:PFObjectResultBlock!) {
    Ride.findLatestByDriverIdInBackground(self, block: block)
  }
  
}

class Ride {
  let parseObj:PFObject

  init(parseObj: PFObject) {
    self.parseObj = parseObj
  }
  
  init(driver:SlugUser, maxSpaces:Int, departure: NSDate) {
    self.parseObj = PFObject(className: "Ride")

    self.parseObj["driver"] = driver.parseObj
    self.parseObj["maxSpaces"] = maxSpaces
    self.parseObj["departure"] = departure
    self.parseObj["riders"] = []
  }
  
  var maxSpaces: Int {
    get {
      return self.parseObj["maxSpaces"] as Int
    }
  }
  
  var departure: NSDate {
    get {
      return self.parseObj["departure"] as NSDate
    }
  }
  
  var riderIds:[String] {
    get {
      return self.parseObj["riders"] as [String]
    }
  }

  
  func hasSpots() -> Bool {
    return self.riderIds.count < self.maxSpaces
  }
  
  class func findByIdInBackground(objectId:String, block: PFObjectResultBlock!) {
    let query = PFQuery(className:"Ride")
    query.getObjectInBackgroundWithId(objectId, block: block)
  }
  
  private func findById(objectId:String) -> Ride {
    let query = PFQuery(className:"Ride")
    let foundParseRide = query.getObjectWithId(objectId)
    return Ride(parseObj: foundParseRide)
  }
  
  class func findLatestByDriverIdInBackground(user:SlugUser, block: PFObjectResultBlock!) {
    let query = PFQuery(className:"Ride")
    query.whereKey("driver", equalTo: user.parseObj)
    query.orderByDescending("departure")
    query.getFirstObjectInBackgroundWithBlock(block)
  }
  
  func grabASpotInBackground(user:SlugUser, block: PFBooleanResultBlock!) {
    Ride.findByIdInBackground(self.parseObj.objectId, block: { (parseRide:PFObject!, error:NSError!) -> Void in
      if(parseRide != nil && error == nil) {
        
        let ride = Ride(parseObj: parseRide)
        if ride.hasSpots() {
          Ride.uncheckedGrapASpotInBackground(self.parseObj.objectId, user: user, block: block)
        } else {
          let error = NSError.withMsg("no spots left")
          block?(false, error)
        }
        
      } else {
        let error = NSError.withMsg("driver canceled the ride")
        block?(false, error)
      }
    })
  }
  
  private class func uncheckedGrapASpotInBackground(rideId:String, user:SlugUser, block: PFBooleanResultBlock!) {
    var query = PFQuery(className:"Ride")
   
     query.getObjectInBackgroundWithId(rideId) {
      (ride: PFObject!, error: NSError!) -> Void in
      if error != nil {
        block?(false, error)
      } else {
        ride.addUniqueObject(user.parseObj.objectId, forKey: "riders")
        ride.saveInBackgroundWithBlock(block)
      }
    }
  }
  
  func releaseMySpotInBackground(user:SlugUser, block: PFBooleanResultBlock!) {
  
  }
  
}