//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Andy on 16.05.2020.
//  Copyright © 2020 AndyRadionov. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var coordinate: CLLocationCoordinate2D?
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        if linkTextField.text!.isEmpty {
            showAlert(title: "Please fill all fields", message: "Link field is required", presenter: self)
            return
        }
        
        enableViews(false)
        
        getCoordinates(addressString: locationTextField.text!) { (coordinate, error) in
            DispatchQueue.main.async {
                self.enableViews(true)
                if (error != nil) {
                    self.showAlert(title: "Location not found", message: "Please correct your location input", presenter: self)
                } else {
                    self.coordinate = coordinate
                    self.performSegue(withIdentifier: "finishAddLocation", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "finishAddLocation") {
            let controller = segue.destination as! FinishAddLocationViewController
            controller.coordinate = coordinate
            controller.link = linkTextField.text
            controller.mapString = locationTextField.text
        }
    }
    
    func getCoordinates( addressString : String, completion: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        CLGeocoder().geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completion(location.coordinate, nil)
                    return
                }
            }
            completion(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    private func enableViews(_ enable: Bool) {
        if enable {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
        locationTextField.isEnabled = enable
        linkTextField.isEnabled = enable
        findLocationButton.isEnabled = enable
        cancelButton.isEnabled = enable
    }
}
