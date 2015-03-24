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
  private var delegates = NSMutableSet()
  var currentLocation: CLLocation?
  
  
  private override init() {
    super.init()
    
    // settiong to a hacked default loc
    self.currentLocation = CLLocation(latitude: 47.605415, longitude: -122.336368)
    
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    self.locationManager.distanceFilter = 50
    self.locationManager.startUpdatingLocation()
  }
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    println("got location")
    self.currentLocation = manager.location
    for d in delegates {
      if let delegate = d as? CLLocationManagerDelegate {
        delegate.locationManager?(manager, didUpdateLocations: locations)
      }
    }
    
    if self.delegates.count <= 0 { self.locationManager.stopUpdatingLocation() }
  }
  
  func register(delegate:CLLocationManagerDelegate) {
    if self.delegates.count <= 0 { self.locationManager.startUpdatingLocation() }
    self.delegates.addObject(delegate)
  }
  
  func unregister(delegate:CLLocationManagerDelegate) {
    self.delegates.removeObject(delegate)
    
    if self.delegates.count <= 0 { self.locationManager.stopUpdatingLocation() }
  }
  
  
  class var sharedInstance: UserLocation {
    return _SharedUserLocation
  }
}