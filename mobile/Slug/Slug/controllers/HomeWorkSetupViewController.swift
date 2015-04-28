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
  @IBOutlet weak var homeImage: UIImageView!
  @IBOutlet weak var workImage: UIImageView!
  @IBOutlet weak var setHome: UIButton!
  @IBOutlet weak var setWork: UIButton!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
   
    self.companyName.text = SlugUser.currentUser()?.company()?.name
    
    if let name = SlugUser.currentUser()?.company()?.name, image = UIImage(named: name.lowercaseString) {
      workImage.image = image
      companyName.text = ""
    }

    
    if let location = UserLocation.sharedInstance.currentLocation {
      CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
        if error != nil {
          println("error in reverse geocoding: \(error.localizedDescription)")
          return
        }
        if let placemark = placemarks.first as? CLPlacemark {
          let addressArray = [placemark.thoroughfare, placemark.subLocality].filter{ $0 != nil}.map{$0!}
          let address = " ".join(addressArray)
          self.homeAddress.text = address
        }
      })
    }
    
    if let attributedText = setHome.titleLabel?.attributedText as? NSMutableAttributedString {
      attributedText.addAttribute(NSKernAttributeName, value: 2.3 , range: NSMakeRange(0, attributedText.length))
      setHome.setAttributedTitle(attributedText, forState: .Normal)
    }
    
    if let attributedText = setWork.titleLabel?.attributedText as? NSMutableAttributedString {
      attributedText.addAttribute(NSKernAttributeName, value: 2.3, range: NSMakeRange(0, attributedText.length))
      setWork.setAttributedTitle(attributedText, forState: .Normal)
    }
    
  }
  
  @IBAction func doneCLicked(sender: AnyObject) {
    if let user = SlugUser.currentUser(), let userCompany = user.company()  {
      if let coordinate = UserLocation.sharedInstance.currentLocation?.coordinate {
        user.home = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        user.work = PFGeoPoint(latitude: userCompany.latitude, longitude: userCompany.longitude)
        user.parseObj.saveInBackgroundWithBlock(nil)
        self.performSegueWithIdentifier("UnwindToRoot", sender: self)
      }
      
    } else {
      self.performSegueWithIdentifier("UnwindToRoot", sender: self)
    }
  }
}
