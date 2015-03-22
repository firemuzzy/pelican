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
}

class Ride {
  let parseObj:PFObject

  var riders:[PFObject] = []

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
  
  
  
}