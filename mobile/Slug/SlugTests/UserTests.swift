//
//  UserTests.swift
//  Slug
//
//  Created by Michael Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit
import XCTest
import Parse

class UserTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    PFUser.logOut()
  }
  
  func testCreatingTestUser() {
    let firstName = "Michael"
    let lastName = "Charkin"
    let email = "mcharkin+slugtest@gmail.com"
    let password = "test"
  
    UserTestUtils.createTestUser(fname: firstName, lname: lastName, email: email, password: password)
    let foundParseUser = PFUser.logInWithUsername(email, password: password)
    
    XCTAssertNotNil(foundParseUser, "user is nil")
    let foundUser = SlugUser(parseUser: foundParseUser!)
    
    let fNameO: String? = firstName
    XCTAssertEqualOptional(foundUser.firstName, fNameO, "firstName did not match")
    XCTAssertEqualOptional(foundUser.lastName, lastName, "lastName did not match")
    XCTAssertEqualOptional(foundUser.email, email, "email did not match")
  }
  
  func testUserCreate() {
    let expectation = expectationWithDescription("ready")
  
    let user = SlugUser(firstName:"Michael", lastName: "Charkin", email: "mcharkin+slug@gmail.com", password: "test")
    user.parseObj.signUpInBackgroundWithBlock { (didSave:Bool, error) -> Void in
      expectation.fulfill()
      
      let foundParseUser = PFUser.logInWithUsername("mcharkin+slug@gmail.com", password: "test")
      
      XCTAssertNotNil(foundParseUser, "user is nil")
      let foundUser = SlugUser(parseUser: foundParseUser!)

      XCTAssertEqualOptional(foundUser.firstName, "Michael", "firstName did not match")
      XCTAssertEqualOptional(foundUser.lastName, "Charkin", "lastName did not match")
      XCTAssertEqualOptional(foundUser.email, "mcharkin+slug@gmail.com", "email did not match")
    }
    
    waitForExpectationsWithTimeout(5, handler: { error in
      XCTAssertNil(error, "Error")
    })
    
//    var query = PFQuery(className:"SlugUser")
//    query.getObjectInBackgroundWithId(user.parseObj.objectId) { (obj: PFObject!, error: NSError!) -> Void in
//      if error == nil && obj != nil {
//        println(obj)
//      } else {
//        XCTFail("shit failed")
//      }
//    }

  }
  
  func testExample() {
    // This is an example of a functional test case.
    XCTAssert(true, "Pass")
  }
  
}
