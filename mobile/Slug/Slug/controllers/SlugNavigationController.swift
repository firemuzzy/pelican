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
  
  @IBInspectable var fontName: String? {
    didSet {
      if let fontName = fontName {
        
        if let font = UIFont(name: fontName, size: 17) {
          self.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.whiteColor()]
          
          UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.whiteColor()], forState: .Normal)
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationBar.barStyle = UIBarStyle.Black
    self.navigationBar.tintColor = UIColor.whiteColor()
    
  }
  
}
