//
//  AccountResponse.swift
//  OnTheMap
//
//  Created by Musaad on 11/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct AccountResponse: Codable {
    let user: UserInfo
}

struct UserInfo: Codable {
    let first_name: String
    let last_name: String
}
