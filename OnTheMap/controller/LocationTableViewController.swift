//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by Andy on 16.05.2020.
//  Copyright © 2020 AndyRadionov. All rights reserved.
//

import UIKit

class LocationTableViewController: BaseLocationsViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (appDelegate.studentLocations.count == 0) {
            loadStudentLocations()
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        ApiClient.deleteSession { [weak self] (success, error) in
            guard let self = self else {
                return
            }

            if let error = error {
                self.showErrorAlert(error, self)
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        loadStudentLocations()
    }
    
    private func loadStudentLocations() {
        loadStudentLocations { (studentLocations, error) in
            self.tableView.reloadData()
        }
    }
}

extension LocationTableViewController: UITableViewDataSource, UITableViewDelegate {
    
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
