// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

extension String {
  func extractEmailDomain() -> String? {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]+)\\.[A-Za-z]{2,4}"
    
    let regex = NSRegularExpression(pattern: emailRegEx, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)
    
    var match = regex?.firstMatchInString(self, options: NSMatchingOptions(0), range: NSMakeRange(0, countElements(self)))

    if let range = match?.rangeAtIndex(1) {
      return (self as NSString).substringWithRange(range)
    } else {
      return nil
    }
  }
}

"mcahrkin@gmail.com".extractEmailDomain()



let seed = UInt32(time(nil))
srand(seed)
let r = rand()
rand() % 4





rand()



