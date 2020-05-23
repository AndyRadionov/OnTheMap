//
//  FinishAddLocationViewController.swift
//  OnTheMap
//
//  Created by Andy on 16.05.2020.
//  Copyright © 2020 AndyRadionov. All rights reserved.
//

import UIKit
import MapKit

class FinishAddLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var coordinate: CLLocationCoordinate2D!
    var mapString: String!
    var link: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = mapString
        mapView.addAnnotation(annotation)
        mapView.setCenter(coordinate, animated: true)
    }
    
    @IBAction func finishTapped(_ sender: Any) {
        enableViews(false)
        
        ApiClient.postStudentLocation(
            longitude: coordinate.longitude,
            latitude: coordinate.latitude,
            mapString: mapString,
            link: link
        ) { (success, error) in
            DispatchQueue.main.async {
                self.enableViews(true)
                if error != nil {
                    self.showErrorAlert(error!, self)
                    return
                }
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func enableViews(_ enable: Bool) {
        if enable {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
        mapView.isZoomEnabled = enable
        mapView.isScrollEnabled = enable
        mapView.isUserInteractionEnabled = enable
        navigationItem.leftBarButtonItem?.isEnabled = enable
        finishButton.isEnabled = enable
    }
}

extension FinishAddLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pinView.canShowCallout = true
        pinView.pinTintColor = .red
        pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        pinView.annotation = annotation
        return pinView
    }
}
