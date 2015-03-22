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
  
  var home: PFGeoPoint? {
    get {
      return self.parseObj["home"] as? PFGeoPoint
    }
    set {
      self.parseObj["home"] = newValue
    }
  }
  
  var work: PFGeoPoint? {
    get {
      return self.parseObj["work"] as? PFGeoPoint
    }
    set {
      self.parseObj["work"] = newValue
    }
  }
  
  func findMyCurrentDrivingRideInBackground(block:PFObjectResultBlock!) {
    Ride.findLatestByDriverIdInBackground(self, block: block)
  }
  
  class func currentUser() -> SlugUser?{
    let user = PFUser.currentUser()
    if user != nil {
      return SlugUser(parseUser: user)
    } else {
      return nil
    }
    
  }
  
}

class RideEnd {
  let parseObj: PFObject
  
  var to: PFGeoPoint? {
    get {
      return self.parseObj["to"] as? PFGeoPoint
    }
  }
  
  init(parseObj: PFObject) {
    self.parseObj = parseObj
  }
  
  init(ride:Ride, to:PFGeoPoint) {
    self.parseObj = PFObject(className: "RideEnd")
    
    self.parseObj["ride"] = ride.parseObj
    self.parseObj["to"] = to
  }
}

class Ride {
  let parseObj:PFObject

  init(parseObj: PFObject) {
    self.parseObj = parseObj
  }
  
  private init() {
    self.parseObj = PFObject(className: "Ride")
  }
  
  // parse only allows one location object per class, so hacks
  class func create(driver:SlugUser, maxSpaces:Int, departure: NSDate, from:PFGeoPoint, to:PFGeoPoint) -> (Ride, RideEnd) {
    let ride = Ride()

    ride.parseObj["driver"] = driver.parseObj
    ride.parseObj["maxSpaces"] = maxSpaces
    ride.parseObj["departure"] = departure
    ride.parseObj["riders"] = []
    ride.parseObj["hasDeparted"] = false
    
    ride.parseObj["from"] = from
    
    let rideEnd = RideEnd(ride: ride, to: to)
    
    return (ride, rideEnd)
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
  
  var driver: PFObject? {
    get {
      return self.parseObj["driver"] as? PFObject
    }
  }
  
  var riderIds:[String] {
    get {
      return self.parseObj["riders"] as [String]
    }
  }
  
  var hasDeparted: Bool {
    get {
      return self.parseObj["departedOn"] as? Bool ?? false
    }
  }

  var from: PFGeoPoint? {
    get {
      return self.parseObj["from"] as? PFGeoPoint
    }
  }

// a hack becasue parse only allows only GeoCoordinate per object
  func save(rideEnd:RideEnd, error: NSErrorPointer) -> Bool {
    if(self.parseObj.save(error)) {
      return rideEnd.parseObj.save(error)
    } else {
      return false
    }
  }

  func saveInBackgroundWithBlock(rideEnd:RideEnd, block: PFBooleanResultBlock?) {
    self.parseObj.saveInBackgroundWithBlock { (didSaveRide:Bool, errorRide:NSError!) -> Void in
      rideEnd.parseObj.saveInBackgroundWithBlock({ (didSave:Bool, error:NSError!) -> Void in
        if(errorRide == nil) {
          block?(didSaveRide && didSave, error)
        } else {
          block?(didSaveRide && didSave, errorRide)
        }
      })
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
  
  func markRideDepartedInBackground(user:SlugUser, block: PFBooleanResultBlock!) {
    user.findMyCurrentDrivingRideInBackground { (ride: PFObject!, error: NSError!) -> Void in
      if error != nil {
        block?(false, error)
      } else if(ride == nil) {
        block?(false, NSError.withMsg("you are not the driver"))
      } else {
        ride["departedOn"] = NSDate()
        ride.saveInBackgroundWithBlock(block)
      }
    }
  }
  
  func findNearByDriversInBackground(start: PFGeoPoint, end:PFGeoPoint, block:PFArrayResultBlock?) {
  }
  
  func releaseMySpotInBackground(user:SlugUser, block: PFBooleanResultBlock!) {
  
  }
  
}