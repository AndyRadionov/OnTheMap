//
//  BaseLocationsViewController.swift
//  OnTheMap
//
//  Created by Andy on 23.05.2020.
//  Copyright © 2020 AndyRadionov. All rights reserved.
//

import UIKit

class BaseLocationsViewController: UIViewController {

    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func loadStudentLocations(completion: @escaping ([StudentLocation], ApiClient.ApiError?) -> Void) {
        ApiClient.getStudentLocations { (locations, error) in
            if error != nil {
                self.showErrorAlert(error!, self)
                return
            }
            self.appDelegate.studentLocations = locations
            completion(locations, nil)
        }
    }
}
