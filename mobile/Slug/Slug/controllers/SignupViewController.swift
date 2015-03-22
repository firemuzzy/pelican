//
//  SignupViewController.swift
//  Slug
//
//  Created by Andrew Charkin on 3/22/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SignupViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var emailField: UITextField!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if self.emailField.canBecomeFirstResponder() {
      self.emailField.becomeFirstResponder()
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    if self.emailField.canResignFirstResponder() {
      self.emailField.resignFirstResponder()
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    let email = textField.text
    let dummypassword = "test"
    let user = SlugUser(firstName: "Name", lastName: "Name", email: email, password: dummypassword)
    
    user.parseObj.signUpInBackgroundWithBlock { (didSignUp, error) -> Void in
      // to let me show different users
      let isUserNameTaken = (error != nil && (error.code == 202))
      
      if didSignUp {
        self.performSegueWithIdentifier("SegueToHomeWorkSetup", sender:self)
      } else if isUserNameTaken {
        PFUser.logInWithUsernameInBackground(email, password: dummypassword, block: { (loggedInUser:PFUser!, error:NSError!) -> Void in
          if(loggedInUser != nil) {
            self.performSegueWithIdentifier("SegueToHomeWorkSetup", sender:self)
          }
        })
      }
    }
    
    return true
  }
  
  override func viewDidLoad() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
  }
  
  func keyboardNotification(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
      let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
      let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
      let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
      let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
      
      self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
      
      
      UIView.animateWithDuration(duration,
        delay: NSTimeInterval(0),
        options: animationCurve,
        animations: { self.view.layoutIfNeeded() },
        completion: nil)
    }
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}