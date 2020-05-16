//
//  LoginResonse.swift
//  OnTheMap
//
//  Created by Andy on 16.05.2020.
//  Copyright © 2020 AndyRadionov. All rights reserved.
//

import Foundation

struct AuthResponse: Codable {
    let account: Account?
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
