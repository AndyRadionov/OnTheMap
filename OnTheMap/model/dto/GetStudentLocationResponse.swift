//
//  GetStudentLocationResponse.swift
//  OnTheMap
//
//  Created by Andy on 14.05.2020.
//  Copyright © 2020 AndyRadionov. All rights reserved.
//

import Foundation

struct GetStudentLocationResponse: Codable {
    let results: [StudentLocation]
}
