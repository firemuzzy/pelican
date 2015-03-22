//
//  RideTableViewCell.swift
//  Slug
//
//  Created by Andrew Charkin on 3/22/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit

class RideTableViewCell: UITableViewCell {
  
  @IBOutlet weak var seatsLeft: UILabel!
  @IBOutlet weak var timeLeft: UILabel!
  @IBOutlet weak var personName: UILabel!
  @IBOutlet weak var fromCompany: UILabel!
  
  func setup(driver: Driver) {
    self.personName.text = driver.name
    self.fromCompany.text = "from \(driver.company)"
    
    self.timeLeft.text = driver.ride.prettyMinutesLeft()
    
    let seatsLeft = driver.ride.seatsLeft()
    if(seatsLeft <= 0) {
      self.seatsLeft.text = "full"
    } else if(seatsLeft == 1) {
      self.seatsLeft.text = "\(seatsLeft) seat left"
    } else {
      self.seatsLeft.text = "\(seatsLeft) seats left"
    }
  }
}
