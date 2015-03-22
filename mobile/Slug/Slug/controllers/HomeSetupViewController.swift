//
//  HomePickerViewController.swift
//  Slug
//
//  Created by Andrew Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit

class HomeSetupViewController: UIViewController {
  
  @IBOutlet weak var slug: UIImageView!
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    var images = [
      UIImage(named: "slug"),
      UIImage(named: "slug2"),
      UIImage(named: "slug3"),
      UIImage(named: "slug4"),
      UIImage(named: "slug5"),
      UIImage(named: "slug6"),
      UIImage(named: "slug5"),
      UIImage(named: "slug4"),
      UIImage(named: "slug3"),
      UIImage(named: "slug2"),
    ].filter{ $0 != nil}.map{$0!}

    self.slug.animationImages = images
    self.slug.animationDuration = 0.75
    self.slug.startAnimating()
    
  }
}
