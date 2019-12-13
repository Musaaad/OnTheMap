//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Musaad on 11/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let results: [StudentInfo]
}

struct StudentInfo: Codable {

    var uniqueKey: String
    var firstName: String
    var lastName: String
    var longitude: Double
    var mediaURL: String
    var latitude: Double
    var mapString: String
    var createdAt: String
    var updatedAt: String
    var objectId: String

}



