//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by Andy on 16.05.2020.
//  Copyright © 2020 AndyRadionov. All rights reserved.
//

import UIKit

class LocationTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (appDelegate.studentLocations.count == 0) {
            loadStudentLocations()
        } else {
            setLocations(locations: appDelegate.studentLocations)
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        OnTheMapClient.deleteSession { (success, error) in
            if (error != nil) {
                self.showErrorAlert(error!, self)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        loadStudentLocations()
    }
    
    @IBAction func addPinTapped(_ sender: Any) {
        let detailController = storyboard?.instantiateViewController(withIdentifier: "addLocationController") as! UINavigationController
        detailController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        navigationController?.showDetailViewController(detailController, sender: self)
    }
    
    private func loadStudentLocations() {
        OnTheMapClient.getStudentLocation { (locations, error) in
            if error != nil {
                self.showErrorAlert(error!, self)
                return
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.studentLocations = locations
            self.setLocations(locations: locations)
        }
    }
    
    private func setLocations(locations: [StudentLocation]) {
        
    }
}
