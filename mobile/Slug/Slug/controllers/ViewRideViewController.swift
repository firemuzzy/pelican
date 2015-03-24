//
//  ViewRideViewController.swift
//  Slug
//
//  Created by Andrew Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit

class ViewRideViewController: UIViewController {
  
  var ride: Ride? { didSet { updateUI() } }
  
  @IBOutlet weak var fromCompany: UILabel!
  @IBOutlet weak var personName: UILabel!
  @IBOutlet weak var departingTime: UILabel!
  @IBAction func join(sender: UIButton) {
    if let user = SlugUser.currentUser() {
      self.ride?.grabASpotInBackground(user, block: nil)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  func updateUI() {
    self.personName?.text = self.ride?.driver?.firstName
    if let company = self.ride?.driver?.company().name {
      self.fromCompany?.text = "from \(company)"
    }
    
    self.departingTime?.text = self.ride?.prettyMinutesLeft()
  }
  
}
