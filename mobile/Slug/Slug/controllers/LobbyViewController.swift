//
//  LobbyViewController.swift
//  Slug
//
//  Created by Andrew Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit
import Parse

let tableCell = "tableCell"

//needs to be a class to act as AnyObject
class Driver {
  let name: String
  let company: String
  let departureTime: String
  
  init(name: String, company: String, departureTime: String) {
    self.name = name
    self.company = company
    self.departureTime = departureTime
  }
}

class LobbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  var refreshControl = UIRefreshControl()
  
  var drivers:[Driver] = [Driver(name: "unknown", company: "unknown", departureTime: "") ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.tableFooterView = UIView()
    
    self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.addSubview(self.refreshControl)
  }
  
  func clearDrivers() {
    drivers = [Driver(name: "unknown", company: "unknown", departureTime: "") ]
  }
  
  func loadDrivers() {
    self.clearDrivers()
    
    if let currentUser = SlugUser.currentUser() {
      PFGeoPoint.geoPointForCurrentLocationInBackground { (currentPoint: PFGeoPoint!, error:NSError!) -> Void in
        if(currentPoint != nil && error == nil) {
          let currentLoc = CLLocation(latitude: currentPoint!.latitude, longitude: currentPoint!.longitude)
          let points = [currentUser.home, currentUser.work]
 
          if let farthestPoint = LocUtils.farthestPoint(points, from: currentLoc) {
            Ride.findNearByDriversInBackground(currentPoint!, end: farthestPoint, block: { (objs:[AnyObject]!, error:NSError!) -> Void in
              
              for obj in objs {
                let parseObj = obj as PFObject
                let ride = Ride(parseObj: parseObj)
                
                let rideDriver = ride.driver!
                
                let driverToShow = Driver(name: rideDriver.firstName, company: rideDriver.companyName(), departureTime: ride.departure.asTime())
                self.drivers.append(driverToShow)
              }
              
              self.tableView.reloadData()
              
            })
          }
          
        }
      }
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
    super.viewWillAppear(animated)
    
    if let selectedRow = self.tableView.indexPathForSelectedRow() {
      self.tableView.deselectRowAtIndexPath(selectedRow, animated: false)
    }
    
    
    //trigger at least 1 location update
    UserLocation.sharedInstance
  }
  
  override func viewDidAppear(animated: Bool) {
    loadDrivers()
  }
  
  override func viewWillDisappear(animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    super.viewWillDisappear(animated)
  }
  
  func refresh(refreshControl: UIRefreshControl) {
    refreshControl.endRefreshing()
    loadDrivers()
  }
  

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return drivers.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(tableCell, forIndexPath: indexPath) as UITableViewCell
    
    let driver = self.drivers[indexPath.row]
    
//    cell.textLabel?.text = driver.name
//    cell.detailTextLabel?.text = driver.departureTime
    
    return cell
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let driver = self.drivers[indexPath.row]
    self.performSegueWithIdentifier("SegueToViewRide", sender: driver)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let viewRideController  = segue.destinationViewController as? ViewRideViewController {
      if let driver = sender as? Driver {
        viewRideController.driver = driver
      }
    }
  }

  
  @IBAction func unwind(segue: UIStoryboardSegue) {
  }
}
