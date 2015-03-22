//
//  utils.swift
//  Slug
//
//  Created by Michael Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import Foundation
import Parse

extension NSError {
  
  class func withMsg(msg: String) -> NSError {
    return NSError(domain: "com.slug", code: 666, userInfo: [NSLocalizedDescriptionKey: msg])
  }
  
}

class LocUtils {
  
  class func farthestPoint(points:[PFGeoPoint?], from: CLLocation?) -> PFGeoPoint? {
    return points.filter{ $0 != nil}.map{
      ($0!, CLLocation(latitude: $0!.latitude, longitude: $0!.longitude).distanceFromLocation(from))
      }.sorted { (left, right) -> Bool in
        return left.1 > right.1
      }.first?.0
  }

}

extension NSDate {
  
  func asTime() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    return dateFormatter.stringFromDate(self)
  }
  
}

extension NSTimeInterval {
  
  var seconds: NSTimeInterval {
    return self
  }
  // TODO: Are aliases possible?
  var second: NSTimeInterval { return self.seconds }
  
  var minutes: NSTimeInterval {
    return self * 60
  }
  var minute: NSTimeInterval { return self.minutes }
  
  var hours: NSTimeInterval {
    return self.minutes * 60
  }
  var hour: NSTimeInterval { return self.hours }
  
  var days: NSTimeInterval {
    return self.hours * 24
  }
  var day: NSTimeInterval { return self.days }
  
  var months: NSTimeInterval {
    return self.days * 31
  }
  var month: NSTimeInterval { return self.months }
  
  
  var years: NSTimeInterval {
    return self.months * 12
  }
  var year: NSTimeInterval { return self.years }
  
  var ago: NSDate {
    return NSDate(timeIntervalSinceNow: -self)
  }
  
  var fromNow: NSDate {
    return NSDate(timeIntervalSinceNow: self)
  }
}

extension NSDate {
  
  func fuzzyEquals(other: NSDate) -> Bool {
    let myInterval = self.timeIntervalSince1970
    let otherInverval = self.timeIntervalSince1970
    let difference = myInterval - otherInverval
    
    return abs(difference) < 0.01
  }
  
}

struct Company {
  let name: String
  let domain: String
  let latitude: Double
  let longitude: Double
  
  init(_ name: String, domain: String, latitude: Double, longitude: Double) {
    self.name = name
    self.latitude = latitude
    self.longitude = longitude
    self.domain = domain
  }
  
  static var Microsoft = Company("Microsoft", domain: "microsoft", latitude: 47.636933, longitude: -122.128658)
  static var Google = Company("Google", domain: "google", latitude: 47.649131, longitude: -122.350681)
  static var Froogal = Company("Froogle", domain: "gmail", latitude: 47.649131, longitude: -122.350681)
  static var Slugg = Company("Slügg", domain: "slugg", latitude: 47.568629, longitude: -122.236443)
}

extension String {
  func extractEmailDomain() -> String? {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]+)\\.[A-Za-z]{2,4}"
    
    let regex = NSRegularExpression(pattern: emailRegEx, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
    
    var match = regex?.firstMatchInString(self, options: NSMatchingOptions(0), range: NSMakeRange(0, countElements(self)))
    
    if let range = match?.rangeAtIndex(1) {
      return (self as NSString).substringWithRange(range).lowercaseString
    } else {
      return nil
    }
  }
  
  func extractCompnayFromEmail() -> Company {
    switch(self.extractEmailDomain() ?? "") {
      case Company.Microsoft.domain: return Company.Microsoft
      case Company.Google.domain: return Company.Google
      case Company.Slugg.domain: return Company.Slugg
      case Company.Froogal.domain: return Company.Froogal
      default: return Company.Slugg
    }
  }
  
}