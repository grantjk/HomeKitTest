//
//  AccessoriesViewController.swift
//  HomeKitTest
//
//  Created by John Grant on 2015-08-17.
//  Copyright © 2015 TWG. All rights reserved.
//

import UIKit
import HomeKit

class AccessoriesViewController: UITableViewController {
    var home:HMHome? {
        didSet {
            self.title = self.home?.name ?? ""
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @IBAction func unwindFromBrowser(segue:UIStoryboardSegue) {
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToBrowse",
            let nav = segue.destinationViewController as? UINavigationController,
            let vc = nav.viewControllers.first as? BrowserViewController {
               vc.home = self.home
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.home?.accessories.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath)
        guard let accessory = self.home?.accessories[indexPath.row] else { fatalError() }

        cell.textLabel?.text = accessory.name

        return cell
    }

}
