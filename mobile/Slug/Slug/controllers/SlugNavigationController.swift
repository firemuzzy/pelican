//
//  SlugNavigationController.swift
//  Slug
//
//  Created by Andrew Charkin on 3/22/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit

@IBDesignable
class SlugNavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
  
  @IBInspectable var barColor: UIColor? {
    didSet {
      self.navigationBar.barTintColor = barColor
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationBar.barStyle = UIBarStyle.Black
    self.navigationBar.tintColor = UIColor.whiteColor()
  }
}
