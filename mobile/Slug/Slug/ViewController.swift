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
    
    if let user = SlugUser.currentUser() {
      if user.home == nil || user.work == nil {
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
    // log out and try again
    PFUser.logOut()
    
    if let user = SlugUser.currentUser() {
      if user.home == nil || user.work == nil {
        self.performSegueWithIdentifier("SegueToHomeSetup", sender:self)
      } else {
        showLobby()
      }
    } else {
      showLoginFlow()
    }
  }
  
  func showLoginFlow() {
    self.performSegueWithIdentifier("SegueToSignup", sender:self)
  }
  
  func showLobby() {
    self.performSegueWithIdentifier("SegueToLobby", sender: self)
  }

  func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  @IBAction func unwind(segue: UIStoryboardSegue) {
  }
}

