//
//  LobbyViewController.swift
//  Slug
//
//  Created by Andrew Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit

let tableCell = "tableCell"

struct Driver {
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
  
  var drivers:[Driver] = [
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04"),
    Driver(name: "Bob", company: "Google", departureTime: "9:04")
  ]
  
  override func viewDidLoad() {
      super.viewDidLoad()

    self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    self.tableView.tableFooterView = UIView()
    
    self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.addSubview(self.refreshControl)
  }
  
  func refresh(refreshControl: UIRefreshControl) {
    refreshControl.endRefreshing()
  }
  

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return drivers.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(tableCell, forIndexPath: indexPath) as UITableViewCell
    
    let driver = self.drivers[indexPath.row]
    
    cell.textLabel?.text = driver.name
    cell.detailTextLabel?.text = driver.departureTime
    
    return cell
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
