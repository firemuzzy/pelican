//
//  LobbyViewController.swift
//  Slug
//
//  Created by Andrew Charkin on 3/21/15.
//  Copyright (c) 2015 Slug. All rights reserved.
//

import UIKit

let tableCell = "tableCell"

class LobbyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
      super.viewDidLoad()

    self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    self.tableView.tableFooterView = UIView()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(tableCell, forIndexPath: indexPath) as UITableViewCell
    cell.backgroundColor = UIColor.blueColor()
    
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
