//
//  BrowserViewController.swift
//  HomeKitTest
//
//  Created by John Grant on 2015-08-17.
//  Copyright © 2015 TWG. All rights reserved.
//

import UIKit
import HomeKit

class BrowserViewController: UITableViewController {
    let browser = HMAccessoryBrowser()
    var home:HMHome?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.browser.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("Start searching...")
        self.browser.startSearchingForNewAccessories()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("Stop searching...")
        self.browser.stopSearchingForNewAccessories()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.browser.discoveredAccessories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath)
        
        let accessory = self.browser.discoveredAccessories[indexPath.row]
        cell.textLabel?.text = accessory.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let home = self.home else { return }
        
        let accessory = self.browser.discoveredAccessories[indexPath.row]
        home.addAccessory(accessory) { error in
            if let error = error {
               print("Error: \(error)")
            }
        }
    }
}

extension BrowserViewController : HMAccessoryBrowserDelegate {
    
    func accessoryBrowser(browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        print("Browser did find accessory: \(accessory)")
        self.tableView.reloadData()
    }
    
    func accessoryBrowser(browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
        print("Browser did remove accessory: \(accessory)")
        self.tableView.reloadData()
    }
}
