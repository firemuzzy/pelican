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

  var email: String? {
    get {
      return self.parseObj.email
    }
  }

  var firstName: String? {
    get {
      return self.parseObj["firstName"] as? String
    }
    set {
      self.parseObj["firstName"] = newValue
    }
  }
  
  var lastName: String? {
    get {
      return self.parseObj["lastName"] as? String
    }
    set {
      self.parseObj["lastName"] = newValue
    }
  }
  
  var home: PFGeoPoint? {
    get {
      let lat = self.parseObj["home_lat"] as? Double
      let lng = self.parseObj["home_lng"] as? Double
      if(lat != nil && lng != nil) {
        return PFGeoPoint(latitude: lat!, longitude: lng!)
      } else {
        return nil
      }
    }
    set {
      self.parseObj["home_lat"] = newValue?.latitude
      self.parseObj["home_lng"] = newValue?.longitude
    }
  }
  
  var work: PFGeoPoint? {
    get {
      let lat = self.parseObj["work_lat"] as? Double
      let lng = self.parseObj["work_lng"] as? Double
      if(lat != nil && lng != nil) {
        return PFGeoPoint(latitude: lat!, longitude: lng!)
      } else {
        return nil
      }
    }
    set {
      self.parseObj["work_lat"] = newValue?.latitude
      self.parseObj["work_lng"] = newValue?.longitude
    }
  }

  func companyName() -> String? {
    return self.email?.extractCompnayFromEmail().name
  }
  
  func company() -> Company? {
    return self.email?.extractCompnayFromEmail()
  }
  
  func findMyCurrentDrivingRideInBackground(block:PFObjectResultBlock!) {
    Ride.findLatestByDriverIdInBackground(self, block: block)
  }
  
  class func currentUser() -> SlugUser? {
    if let user = PFUser.currentUser() {
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
  
  init(driver:SlugUser, to:PFGeoPoint) {
    self.parseObj = PFObject(className: "RideEnd")
    
    self.parseObj["driver"] = driver.parseObj
    self.parseObj["to"] = to
  }
}

extension PFObject {
  var parseDriver: PFUser? {
    get {
      return self["driver"] as? PFUser
    }
  }
  
  var driver: SlugUser? {
    get {
      if let r = self.parseDriver {
        return SlugUser(parseUser: r)
      } else {
        return nil
      }
    }
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
  class func create(driver:SlugUser, maxSpaces:Int, departure: NSDate, from:PFGeoPoint, to:PFGeoPoint) -> Ride {
    let rideEnd = RideEnd(driver: driver, to: to)
    
    let ride = Ride()

    ride.parseObj["driver"] = driver.parseObj
    ride.parseObj["maxSpaces"] = maxSpaces
    ride.parseObj["departure"] = departure
    ride.parseObj["riders"] = []
    ride.parseObj["hasDeparted"] = false
    
    ride.parseObj["from"] = from
    ride.parseObj["rideEnd"] = rideEnd.parseObj
    
    return ride
  }
  
  var maxSpaces: Int? {
    get {
      return self.parseObj["maxSpaces"] as? Int
    }
  }
  
  var departure: NSDate? {
    get {
      return self.parseObj["departure"] as? NSDate
    }
  }
  
//  var driver: PFObject? {
//    get {
//      return self.parseObj["driver"] as? PFObject
//    }
//  }
  
  var riderIds:[String]? {
    get {
      return self.parseObj["riders"] as? [String]
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
  
  var rideEnd: RideEnd? {
    get {
      if let r = self.parseObj["rideEnd"] as? PFObject {
        return RideEnd(parseObj: r)
      } else {
        return nil
      }
    }
  }
 
  var driver: SlugUser? {
    get {
      if let r = self.parseObj["driver"] as? PFUser {
        return SlugUser(parseUser: r)
      } else {
        return nil
      }
    }
  }
  
  func hasSpots() -> Bool? {
    if let riderIds = self.riderIds, let maxSpaces = self.maxSpaces {
      return riderIds.count < maxSpaces
    } else {
      return nil
    }
  }
  
  func seatsLeft() -> Int? {
    if let maxSpaces = self.maxSpaces, let ridersCount = self.riderIds?.count {
      return maxSpaces - ridersCount
    } else {
      return nil
    }
  }
  
  func minutesLeft() -> Int? {
    if let departure = self.departure {
      let seconds = -NSDate().timeIntervalSinceDate(departure)
      return Int(seconds) / 60
    } else {
      return nil
    }
  }
  
  func prettyMinutesLeft() -> String {
    if let minutesLeft = minutesLeft() {
      if(minutesLeft < 0) {
        return "departed"
      }
      
      let minutesOfHour = minutesLeft % 60
      let hours = minutesLeft / 60
      
      if (hours > 0) {
        return "\(hours)h \(minutesOfHour)m"
      } else {
        return "\(minutesOfHour)m"
      }

    } else {
      return "error"
    }
  }
  
  class func findByIdInBackground(objectId:String, block: PFObjectResultBlock!) {
    let query = PFQuery(className:"Ride")
    query.includeKey("rideEnd")
    query.getObjectInBackgroundWithId(objectId, block: block)
  }
  
  private func findById(objectId:String) -> Ride? {
    let query = PFQuery(className:"Ride")
    query.includeKey("rideEnd")

    if let foundParseRide = query.getObjectWithId(objectId) {
      return Ride(parseObj: foundParseRide)
    } else {
      return nil
    }
  }
  
  class func findLatestByDriverIdInBackground(user:SlugUser, block: PFObjectResultBlock!) {
    let query = PFQuery(className:"Ride")
    query.includeKey("rideEnd")

    query.whereKey("driver", equalTo: user.parseObj)
    query.orderByDescending("departure")
    query.getFirstObjectInBackgroundWithBlock(block)
  }
  
  func grabASpotInBackground(user:SlugUser, block: PFBooleanResultBlock!) {
    if let objectId = self.parseObj.objectId {
      Ride.findByIdInBackground(objectId, block: { (parseRideO, errorO) -> Void in
        if let parseRide = parseRideO {
          let ride = Ride(parseObj: parseRide)
          
          if let hasSpots = ride.hasSpots(), let objectId = self.parseObj.objectId where hasSpots {
            Ride.uncheckedGrapASpotInBackground(objectId, user: user, block: block)
          } else {
            let error = NSError.withMsg("no spots left")
            block?(false, error)
          }
          
        } else if let error = errorO {
          
        } else {
          let error = NSError.withMsg("driver canceled the ride")
          block?(false, error)
        }
      })
    } else {
      let error = NSError.withMsg("user object does not have an objectId")
      block?(false, error)
    }
  }
  
  private class func uncheckedGrapASpotInBackground(rideId:String, user:SlugUser, block: PFBooleanResultBlock!) {
    var query = PFQuery(className:"Ride")
    query.getObjectInBackgroundWithId(rideId, block: { (parseRideO, errorO) -> Void in
      if let error = errorO {
        block?(false, error)
      } else if let parseRide = parseRideO, let userObjectId = user.parseObj.objectId {
        parseRide.addUniqueObject(userObjectId, forKey: "riders")
        parseRide.saveInBackgroundWithBlock(block)
      } else {
        let error = NSError.withMsg("driver canceled the ride")
        block?(false, error)
      }
    })
  }
  
  func markRideDepartedInBackground(user:SlugUser, block: PFBooleanResultBlock!) {
    user.findMyCurrentDrivingRideInBackground { (parseRideO, errorO) -> Void in
      if let error = errorO {
        block?(false, error)
      } else if let parseRide = parseRideO  where parseRide.parseDriver?.objectId == user.parseObj.objectId {
        parseRide["departedOn"] = NSDate()
        parseRide.saveInBackgroundWithBlock(block)
      } else {
        block?(false, NSError.withMsg("you are not the driver"))
      }
    }
  }
  
  class func findNearByDriversInBackground(start: PFGeoPoint, end:PFGeoPoint, block:PFArrayResultBlock?) {
    var queryForToInRideEnd = PFQuery(className: "RideEnd")
    queryForToInRideEnd.whereKey("to", nearGeoPoint: end, withinMiles: 0.70)

    var query = PFQuery(className: "Ride")
    query.whereKey("from", nearGeoPoint: start, withinMiles: 0.70)
    query.whereKey("rideEnd", matchesQuery: queryForToInRideEnd)
    query.includeKey("rideEnd")
    query.includeKey("driver")
    
    query.findObjectsInBackgroundWithBlock(block)
  }
  
  func releaseMySpotInBackground(user:SlugUser, block: PFBooleanResultBlock!) {
  
  }
  
}