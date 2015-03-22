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
    
//    SlugUser.currentUser()?.findMyCurrentDrivingRideInBackground({ (data, error) -> Void in
//      if data != nil {
//        let ride = Ride(parseObj: data)
//        self.maxSpaces = ride.maxSpaces
//        self.departure = ride.departure
//        
//        for seat in self.seats {
//          if seat.tag == ride.maxSpaces {
//            seat.selected = true
//          }
//        }
//      }
//    })
    
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
      let farthestPoint  = LocUtils.farthestPoint([slugUser.work, slugUser.home], from: currentLocationOpt)
      
      switch (self.maxSpaces, self.departure, currentLocationOpt, farthestPoint) {
        case (.Some(let maxSpaces), .Some(let departure), .Some(let currentLocation), .Some(let farthestPoint)):
          let clPoint = PFGeoPoint(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
          
          let ride = Ride.create(slugUser, maxSpaces: maxSpaces, departure: departure, from: clPoint, to: farthestPoint)
          ride.parseObj.saveInBackgroundWithBlock(nil)
          
          self.performSegueWithIdentifier("unwind", sender: self)
//          self.dismissViewControllerAnimated(true, completion: nil)
          break
        default: break
      }
      
    }
  }
  
}
