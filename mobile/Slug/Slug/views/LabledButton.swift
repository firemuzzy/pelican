//
//  LabledButton.swift
//  Slug
//
//  Created by Andrew Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit

@IBDesignable public class LabledButton: UIButton {
  var textLabel: UILabel!
  var iconView: UIView!
  
  @IBInspectable public var title: String? {
    didSet {
      self.textLabel.text = title
    }
  }
  
  @IBInspectable public var icon: UIImage? {
    didSet {
//      self.iconView.image = icon
    }
  }
  
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureView()
  }
  
  init() {
    super.init(frame: CGRectZero)
    configureView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
  }
  
  func configureView() {
    self.textLabel = UILabel()
    self.textLabel.textAlignment = .Center
    self.textLabel.adjustsFontSizeToFitWidth = true
    self.textLabel.font = UIFont.boldSystemFontOfSize(40)
    self.textLabel.numberOfLines = 0
    self.textLabel.minimumScaleFactor = 0.01
    self.textLabel.textColor = UIColor.whiteColor()
    self.textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.textLabel.setContentHuggingPriority(750, forAxis: UILayoutConstraintAxis.Vertical)
    self.textLabel.backgroundColor = UIColor.blueColor()
    self.addSubview(self.textLabel)
    
    
    self.iconView = UIView()
    self.iconView.backgroundColor = UIColor.yellowColor()
    self.addSubview(self.iconView)
    
    self.addConstraint(NSLayoutConstraint(item: self.iconView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.iconView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.iconView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.iconView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))


    self.constrain(.Bottom, relation: .Equal, otherView: self.textLabel, otherAttribute: .Bottom, multiplier: 1, constant: 0)
      .constrain(.CenterX, relation: .Equal, otherView: self.textLabel, otherAttribute: .CenterX, multiplier: 1, constant: 0)
      .constrain(.Width, relation: .Equal, otherView: self.textLabel, otherAttribute: .Width, multiplier: 1, constant: 0)
    
    
    self.backgroundColor = UIColor.blackColor()
  }
  
  
}
