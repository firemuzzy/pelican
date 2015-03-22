//
//  BorderedTextField.swift
//  Slug
//
//  Created by Andrew Charkin on 3/22/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit

@IBDesignable
public class BorderedTextField: UITextField {
  
  private var backgroundDefaultColor:UIColor?
  
  @IBInspectable public var borderColor: UIColor? {
    didSet {
      self.layer.borderColor = borderColor?.CGColor
      self.layer.borderWidth = 1.0
      self.layer.cornerRadius = 5
    }
  }
  
  @IBInspectable public var backgroundEditingColor: UIColor?
  
  public override func textRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, 10, 12)
  }
  
  public override func editingRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, 10, 12)
  }
  
  public override func becomeFirstResponder() -> Bool {
    let outcome = super.becomeFirstResponder()
    if outcome {
      self.backgroundDefaultColor = self.backgroundColor
      self.backgroundColor = backgroundEditingColor
    }
    return outcome
  }
  
  
  public override func resignFirstResponder() -> Bool {
    let outcome = super.becomeFirstResponder()
    if outcome {
      self.backgroundColor = backgroundDefaultColor
    }
    return outcome
  }
  
  
}
