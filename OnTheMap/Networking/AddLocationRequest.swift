//
//  AddLocationRequest.swift
//  OnTheMap
//
//  Created by Musaad on 11/18/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct AddLocationRequest: Codable {
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
}
