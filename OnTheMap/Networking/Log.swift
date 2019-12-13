//
//  Log.swift
//  OnTheMap
//
//  Created by Musaad on 11/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct Account: Codable{
    var registered: Bool
    var key: String
}

struct SessionResponse: Codable {
    var id: String
    var expiration: String
}

struct LoginResponse: Codable {
    var account: Account
    var session: SessionResponse
}

struct ClientError: Codable{
    var status: Int
    var error: String
}

extension ClientError: LocalizedError{
    var errorDescription: String? {
        return error
    }
}

