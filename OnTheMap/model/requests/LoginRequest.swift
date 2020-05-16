//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Andy on 16.05.2020.
//  Copyright © 2020 AndyRadionov. All rights reserved.
//

import Foundation

struct LoginRequest: Encodable {
    let udacity: Credentials
    
    init(username: String, password: String) {
        udacity = Credentials(username: username, password: password)
    }
}

struct Credentials: Encodable {
    let username: String
    let password: String
}
