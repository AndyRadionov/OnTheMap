//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Andy on 15.05.2020.
//  Copyright © 2020 AndyRadionov. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
}
