//
//  InputViewController.swift
//  HomeKitTest
//
//  Created by John Grant on 2015-08-17.
//  Copyright © 2015 TWG. All rights reserved.
//

import UIKit
import HomeKit

class InputViewController: UIViewController {

    let homeManager = HMHomeManager()
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeManager.delegate = self
    }
    
    @IBAction func save(sender: AnyObject) {
        guard let name = self.textField.text else { return }
        
        self.homeManager.addHomeWithName(name) { home, error in
            if let error = error {
                print("Error: \(error)")
            }else {
                print("Saved: \(home!)")
            }
            
        }
    }
}
extension InputViewController: HMHomeManagerDelegate {
    
    func homeManagerDidUpdateHomes(manager: HMHomeManager) {
        print("Home Manager did Update Homes: \(manager.homes)")
        self.homeManager.primaryHome?.delegate = self
        print("primary: \(unsafeAddressOf(self.homeManager.primaryHome!))")
        print("primary: \(homeManager.primaryHome?.delegate)")
    }
    
    func homeManager(manager: HMHomeManager, didAddHome home: HMHome) {
        print("Home Manager did add home: \(home)")
    }
    
    func homeManager(manager: HMHomeManager, didRemoveHome home: HMHome) {
        print("Home Manager did remove home: \(home)")
    }
    
    func homeManagerDidUpdatePrimaryHome(manager: HMHomeManager) {
        print("Home Manager did update primary home")
    }
}

extension InputViewController : HMHomeDelegate {
    
}