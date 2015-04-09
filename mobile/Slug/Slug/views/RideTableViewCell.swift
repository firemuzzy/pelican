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
  
  func setup(ride: Ride) {
    self.personName.text = ride.driver?.firstName
    self.timeLeft.text = ride.prettyMinutesLeft()
    
    if let company = ride.driver?.company() {
      self.fromCompany.text = "from \(company.name)"
    }
    
    let seatsLeft = ride.seatsLeft()

    switch ride.seatsLeft() {
      case let x where x < 0: self.seatsLeft.text = "full"
      case .Some(1): self.seatsLeft.text = "\(seatsLeft) seat left"
      default: self.seatsLeft.text = "\(seatsLeft) seats left"
    }

  }
}
