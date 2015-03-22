//
//  HomeWorkSetupViewController.swift
//  Slug
//
//  Created by Andrew Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit
import Parse

class HomeWorkSetupViewController: UIViewController {

  @IBOutlet weak var homeAddress: UILabel!
  @IBOutlet weak var companyName: UILabel!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
   
    self.companyName.text = SlugUser.currentUser()?.companyName()
    
    if let location = UserLocation.sharedInstance.currentLocation {
      CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
        if error != nil {
          println("error in reverse geocoding: \(error.localizedDescription)")
          return
        }
        if let placemark = placemarks.first as? CLPlacemark {
          println("postal: \(placemark.locality)")
          placemark.country
        }
        
        
      })
    }
  }
}
