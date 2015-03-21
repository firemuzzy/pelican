//
//  RichViews.swift
//  Slug
//
//  Created by Andrew Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import Foundation


import UIKit

func constraint(item1: UIView, attribute1: NSLayoutAttribute, relation: NSLayoutRelation, item2: UIView, attribute2: NSLayoutAttribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
  return NSLayoutConstraint(item: item1, attribute: attribute1, relatedBy: relation, toItem: item2, attribute: attribute2, multiplier: multiplier, constant: constant)
}

func constraint(item1: UIView, attribute1: NSLayoutAttribute, relation: NSLayoutRelation, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) -> NSLayoutConstraint {
  return NSLayoutConstraint(item: item1, attribute: attribute1, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: multiplier, constant: constant)
}

extension UIView {
  public func constrain(view: UIView, attribute: NSLayoutAttribute, relation: NSLayoutRelation, otherView: UIView, otherAttribute: NSLayoutAttribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0, priority: UILayoutPriority = 1000) -> UIView {
    let c = constraint(view, attribute, relation, otherView, otherAttribute, multiplier: multiplier, constant: constant)
    c.priority = priority
    self.addConstraint(c)
    return self
  }
  
  public func constrain(attribute: NSLayoutAttribute, relation: NSLayoutRelation, otherView: UIView, otherAttribute: NSLayoutAttribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0, priority: UILayoutPriority = 1000) -> UIView {
    let c = constraint(self, attribute, relation, otherView, otherAttribute, multiplier: multiplier, constant: constant)
    c.priority = priority
    self.addConstraint(c)
    return self
  }
  
  public func constrain(attribute: NSLayoutAttribute, relation: NSLayoutRelation, multiplier : CGFloat = 1.0, constant: CGFloat, priority: UILayoutPriority = 1000) -> UIView {
    let c = constraint(self, attribute, relation, multiplier: multiplier, constant: constant)
    c.priority = priority
    self.addConstraint(c)
    return self
  }
  
}