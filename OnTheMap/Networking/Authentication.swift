//
//  Authentication.swift
//  OnTheMap
//
//  Created by Musaad on 11/23/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct Authentication {
    
    static var userPosted = StudentInfo(uniqueKey: "", firstName: "", lastName: "", longitude: 0, mediaURL: "", latitude: 0, mapString: "", createdAt: "", updatedAt: "", objectId: "")
    
    static var key = ""
    static var userList: [StudentInfo] = []
    static var sessionId: String = ""

}
