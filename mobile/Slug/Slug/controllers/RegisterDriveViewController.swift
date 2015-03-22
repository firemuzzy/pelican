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
    if let maxSpaces = self.maxSpaces {
      if let departure = self.departure {
        if let slugUser = SlugUser.currentUser() {
          let ride = Ride.create(slugUser, maxSpaces: maxSpaces, departure: departure, from: slugUser.work!, to: slugUser.work!)
          ride.parseObj.saveInBackgroundWithBlock(nil)
          
          self.dismissViewControllerAnimated(true, completion: nil)
        }
      }
    }
  }
}
