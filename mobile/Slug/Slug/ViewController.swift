//
//  ViewController.swift
//  Slug
//
//  Created by Michael Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, CLLocationManagerDelegate {

  var locationManager:CLLocationManager?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let testObj = PFObject(className: "TestObject")
    testObj.setValue("bar", forKey: "foo")
    testObj.saveInBackgroundWithBlock(nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    UserLocation.sharedInstance
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    

//    self.performSegueWithIdentifier("SegueToSignup", sender:self)
//    return
    
    if let user = SlugUser.currentUser() {
      if user.home == nil {
        showSetupFlow()
      } else {
        showLobby()
      }
    } else {
      showLoginFlow()
    }
  }
  
  //home setup
  func showSetupFlow() {
    self.performSegueWithIdentifier("SegueToSignup", sender:self)
    
    
//    if let currentLocation = UserLocation.sharedInstance.currentLocation {
//      let homePoint = PFGeoPoint(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
//      
//      if let user = SlugUser.currentUser() {
//        user.home = homePoint
//        user.parseObj.saveInBackgroundWithBlock(nil)
//      }
//      
//    }
  }
  
  func showLoginFlow() {
    var logInViewController = PFLogInViewController()
    logInViewController.delegate = self
    
    var signUpViewController = PFSignUpViewController()
    signUpViewController.delegate = self
    
    logInViewController.signUpController = signUpViewController
    
    self.presentViewController(logInViewController, animated: true, completion: nil)
  }
  
  func showLobby() {
    self.performSegueWithIdentifier("SegueToLobby", sender: self)
  }

  func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}

