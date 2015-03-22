//
//  HomeWorkSetupViewController.swift
//  Slug
//
//  Created by Andrew Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit

class HomeWorkSetupViewController: UIViewController {

  @IBOutlet weak var homeAddress: UILabel!
  @IBOutlet weak var companyName: UILabel!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
   
    self.companyName.text = SlugUser.currentUser()?.companyName()
    
  }
}
