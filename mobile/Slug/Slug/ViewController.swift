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

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

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
      
      var logInViewController = PFLogInViewController()
      logInViewController.delegate = self
      
      var signUpViewController = PFSignUpViewController()
      signUpViewController.delegate = self
      
      logInViewController.signUpController = signUpViewController
      
      self.presentViewController(logInViewController, animated: true, completion: nil)
    }
  }

  func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
    
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}

