//
//  RegisterDriveViewController.swift
//  Slug
//
//  Created by Andrew Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit

class RegisterDriveViewController: UIViewController {
  @IBOutlet var seats: [UIButton]!
  
  @IBAction func selectSeats(sender: UIButton) {
    for seat in seats {
      seat.selected = false
    }
    sender.selected = true
  }

  @IBAction func depart5Minutes(sender: UIButton) {
    
  }
  @IBAction func depart15Minutes(sender: UIButton) {
    
  }
  @IBAction func depart30Minutes(sender: UIButton) {
    
  }
  
  @IBAction func unwind(segue: UIStoryboardSegue) {
    self.view.backgroundColor = UIColor.redColor()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  @IBAction func done(sender: UIButton) {
    println("hERE")
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
