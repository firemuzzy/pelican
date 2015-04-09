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

class LobbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  var refreshControl = UIRefreshControl()
  
  var rides:[Ride] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.tableFooterView = UIView()
    
    self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.addSubview(self.refreshControl)
    
  }
  
  func clearDrivers() {
    rides = []
  }
  
  func loadDrivers() {
    self.clearDrivers()
    
    if let user = SlugUser.currentUser(), location = UserLocation.sharedInstance.currentLocation {
      let currentPoint = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
      
      let points = [user.home, user.work]
      
      if let farthestPoint = LocUtils.farthestPoint(points, from: location) {
        println("getting drivers from \(currentPoint)")
        println("getting drivers to \(farthestPoint)")
        
        Ride.findNearByDriversInBackground(currentPoint, end: farthestPoint, block: { (objsO, errorO) -> Void in
          if let objs = objsO {
            for obj in objs {
              if let parseObj = obj as? PFObject {
                let ride = Ride(parseObj: parseObj)
                self.rides.append(ride)
              }
            }
          } else if let error = errorO {
            self.rides = []
          } else {
            self.rides = []
          }
          self.rides.sort({ (one, two) -> Bool in return one.minutesLeft() < two.minutesLeft() })
          self.tableView.reloadData()
        })
      }

    }

  }
  
  override func viewWillAppear(animated: Bool) {
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
  
  func refresh(refreshControl: UIRefreshControl) {
    refreshControl.endRefreshing()
    loadDrivers()
  }
  

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return rides.count }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(tableCell, forIndexPath: indexPath) as! RideTableViewCell

    cell.setup(self.rides[indexPath.row])
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    
    return cell
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let ride = self.rides[indexPath.row]
    self.performSegueWithIdentifier("SegueToViewRide", sender: ride)
  }
  
  func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
    if let cell = tableView.cellForRowAtIndexPath(indexPath) {
      cell.contentView.backgroundColor = UIColor(red: 58.0/255.0, green: 121.0/255.0, blue: 175.0/255.0, alpha:0.2)
    }
  }
  
  func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
    if let cell = tableView.cellForRowAtIndexPath(indexPath) {
      cell.contentView.backgroundColor = UIColor.clearColor()
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let viewRideController  = segue.destinationViewController as? ViewRideViewController {
      if let ride = sender as? Ride {
        viewRideController.ride = ride
      }
    }
  }

  
  @IBAction func logout(sender: UIBarButtonItem) {
    PFUser.logOut()
    self.performSegueWithIdentifier("UnwindToRoot", sender: self)
  }
  
  @IBAction func unwind(segue: UIStoryboardSegue) {

  }
}
