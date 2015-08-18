//
//  ViewController.swift
//  HomeKitTest
//
//  Created by John Grant on 2015-08-17.
//  Copyright © 2015 TWG. All rights reserved.
//

import UIKit
import HomeKit

class ViewController: UITableViewController {
    
    let homeManager = HMHomeManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeManager.delegate = self
        self.updateTitle(self.homeManager.homes.count)
        print("primary: \(homeManager.primaryHome)")
    }
    
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        print("primary: \(homeManager.primaryHome?.delegate)")
    }
    
    @IBAction func cancelInput(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func saveInput(segue:UIStoryboardSegue) {
        guard let vc = segue.sourceViewController as? InputViewController,
            let name = vc.textField.text else { return }
        
        self.homeManager.addHomeWithName(name) { home, error in
            print(error)
            self.tableView.reloadData()
        }
    }
    
    private func updateTitle(count:Int) {
        switch count {
        case 0: self.title = "No homes found"
        case 1: self.title = "1 home found"
        default: self.title = "\(count) homes found"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToHome",
            let vc = segue.destinationViewController as? AccessoriesViewController,
            let indexPath = self.tableView.indexPathForSelectedRow {
               vc.home = self.homeManager.homes[indexPath.row]
        }
    }
}

extension ViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeManager.homes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell", forIndexPath: indexPath)
        
        let home = self.homeManager.homes[indexPath.row]
        cell.textLabel?.text = home.name
        cell.detailTextLabel?.text = "\(home.rooms.count) rooms | \(home.accessories.count) accessories"
        cell.accessoryType = home == self.homeManager.primaryHome ? .Checkmark : .None
        return cell
    }
}

extension ViewController:HMHomeDelegate {
}

extension ViewController: HMHomeManagerDelegate {
    
    func homeManagerDidUpdateHomes(manager: HMHomeManager) {
        print("Home Manager did Update Homes: \(manager.homes)")
        self.homeManager.primaryHome?.delegate = self
        print("primary: \(homeManager.primaryHome?.delegate)")
        print("primary: \(unsafeAddressOf(self.homeManager.primaryHome!))")
        
        self.tableView.reloadData()
        self.updateTitle(self.homeManager.homes.count)
    }
    
    func homeManager(manager: HMHomeManager, didAddHome home: HMHome) {
        print("Home Manager did add home: \(home)")
        self.tableView.reloadData()
    }
    
    func homeManager(manager: HMHomeManager, didRemoveHome home: HMHome) {
        print("Home Manager did remove home: \(home)")
        self.tableView.reloadData()
    }
    
    func homeManagerDidUpdatePrimaryHome(manager: HMHomeManager) {
        print("Home Manager did update primary home")
        self.tableView.reloadData()
    }
}

