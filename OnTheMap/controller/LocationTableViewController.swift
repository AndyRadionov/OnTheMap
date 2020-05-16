//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by Andy on 16.05.2020.
//  Copyright © 2020 AndyRadionov. All rights reserved.
//

import UIKit

class LocationTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (appDelegate.studentLocations.count == 0) {
            loadStudentLocations()
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
    
    private func loadStudentLocations() {
        OnTheMapClient.getStudentLocations { (locations, error) in
            if error != nil {
                self.showErrorAlert(error!, self)
                return
            }
            self.appDelegate.studentLocations.removeAll()
            self.appDelegate.studentLocations.append(contentsOf: locations)
            self.tableView.reloadData()
        }
    }
}

extension LocationTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        let location = appDelegate.studentLocations[indexPath.row]
        
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.detailTextLabel?.text = location.mediaURL
        cell.imageView?.image = UIImage(named: "pin")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = appDelegate.studentLocations[indexPath.row]
        UIApplication.shared.open(URL(string: location.mediaURL)!)
    }
}
