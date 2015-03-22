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
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if(PFUser.currentUser() == nil) {
      showLoginFlow()
    } else {
      let slugUser = SlugUser(parseUser: PFUser.currentUser())
      
      if slugUser.home == nil {
        showSetupFlow()
      } else {
        showLobby()
      }
    }
  }
  
  //home setup
  func showSetupFlow() {
    locationManager = CLLocationManager()
    locationManager?.requestWhenInUseAuthorization()
    locationManager?.delegate = self
    locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    locationManager?.startUpdatingLocation()
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
    if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("lobby") as? UIViewController {
      self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
      self.presentViewController(vc, animated: false, completion: nil)
    }
  }

  func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    if let location = locations.first as? CLLocation {
      let homePoint = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

      let slugUser = SlugUser(parseUser: PFUser.currentUser())
      slugUser.home = homePoint
      slugUser.parseObj.saveInBackgroundWithBlock(nil)
    }
    
    manager.stopUpdatingLocation()
  }
}

