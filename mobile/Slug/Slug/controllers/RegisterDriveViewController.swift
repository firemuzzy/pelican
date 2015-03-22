//
//  RegisterDriveViewController.swift
//  Slug
//
//  Created by Andrew Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit
import Parse

class RegisterDriveViewController: UIViewController {

  var maxSpaces: Int?
  var departure: NSDate?
  
  @IBOutlet var seats: [UIButton]!
  @IBOutlet var departureTimes: [UIButton]!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    SlugUser.currentUser()?.findMyCurrentDrivingRideInBackground({ (data, error) -> Void in
      if data != nil {
        let ride = Ride(parseObj: data)
        self.maxSpaces = ride.maxSpaces
        self.departure = ride.departure
        
        for seat in self.seats {
          if seat.tag == ride.maxSpaces {
            seat.selected = true
          }
        }
      }
    })
    
    //get location
    UserLocation.sharedInstance
    
  }
  
  
  @IBAction func selectSeats(sender: UIButton) {
    for seat in self.seats {
      seat.selected = false
    }
    sender.selected = true
    self.maxSpaces = sender.tag
  }

  @IBAction func depart5Minutes(sender: UIButton) {
    for departureButton in self.departureTimes {
      departureButton.selected = false
    }
    self.departure = NSDate().dateByAddingTimeInterval(60*5)
    sender.selected = true;
  }
  @IBAction func depart15Minutes(sender: UIButton) {
    for departureButton in self.departureTimes {
      departureButton.selected = false
    }
    self.departure = NSDate().dateByAddingTimeInterval(60*15)
    sender.selected = true;
  }
  @IBAction func depart30Minutes(sender: UIButton) {
    for departureButton in self.departureTimes {
      departureButton.selected = false
    }
    self.departure = NSDate().dateByAddingTimeInterval(60*15)
    sender.selected = true;
  }
  
  @IBAction func done(sender: UIButton) {
    if let slugUser = SlugUser.currentUser() {
      let currentLocationOpt = UserLocation.sharedInstance.currentLocation
      let farthestPoint  = self.farthestPoint([slugUser.work, slugUser.home], from: currentLocationOpt)
      
      switch (self.maxSpaces, self.departure, currentLocationOpt, farthestPoint) {
        case (.Some(let maxSpaces), .Some(let departure), .Some(let currentLocation), .Some(let farthestPoint)):
          let clPoint = PFGeoPoint(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
          
          let ride = Ride.create(slugUser, maxSpaces: maxSpaces, departure: departure, from: slugUser.work!, to: slugUser.work!)
          ride.parseObj.saveInBackgroundWithBlock(nil)
          self.dismissViewControllerAnimated(true, completion: nil)
          break
        default: break
      }
      
    }
  }
  
  func farthestPoint(points:[PFGeoPoint?], from: CLLocation?) -> PFGeoPoint? {
    return points.filter{ $0 != nil}.map{
      ($0!, CLLocation(latitude: $0!.latitude, longitude: $0!.longitude).distanceFromLocation(from))
    }.sorted { (left, right) -> Bool in
      return left.1 > right.1
    }.first?.0
  }
}
