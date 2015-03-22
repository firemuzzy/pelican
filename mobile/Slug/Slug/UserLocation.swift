//
//  UserLocation.swift
//  Slug
//
//  Created by Andrew Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import MapKit

private let _SharedUserLocation = UserLocation()

class UserLocation: NSObject, CLLocationManagerDelegate {
  
  private var locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  
  
  private override init() {
    super.init()
    
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    self.locationManager.distanceFilter = 50
    self.locationManager.startUpdatingLocation()
  }
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    self.currentLocation = manager.location
  }
  
  
  class var sharedInstance: UserLocation {
    return _SharedUserLocation
  }
}