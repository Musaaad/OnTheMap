//
//  UdacityMapClient.swift
//  OnTheMap
//
//  Created by Musaad on 11/18/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class UdacityMapClient {
    
    enum EndPoint {
        
        case session
        case locations
        case recentLocations(Int)
        case publicUser(String)
        var stringValue: String{
            switch self {
            case .session:
                return "https://onthemap-api.udacity.com/v1/session"
            case .locations:
                return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .recentLocations(let amount):
                return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=\(amount)&order=-updatedAt"
            case .publicUser(let userId):
                return "https://onthemap-api.udacity.com/v1/users/\(userId)"
            }
        }
        //returning a URL
        var url: URL{
            return URL(string: stringValue)!
        }
    }
    
    
    
    class func getLocations(url: URL, completion: @escaping (StudentLocation?, Error?) -> Void) {
        taskForGetRequest(url: url, responseType: StudentLocation.self) { (response, error) in
            if let response = response{
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            }
            else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    class func requestSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        let loginSession = LoginSession(udacity: SessionRequest(username: username, password: password))
        
        taskForPostRequest(url: EndPoint.session.url, responseType: LoginResponse.self, body: loginSession) { (response, error) in
            if let response = response{
                Authentication.sessionId = response.session.id
                Authentication.key = response.account.key
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
            else{
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
    
    
    
    class func loggingOut(completion: @escaping () -> Void) {
        
        var request = URLRequest(url: EndPoint.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            let jDecoder = JSONDecoder()
            let range = 5 ..< data.count
            let newData = data.subdata(in: range)
            
            do {
                _ = try jDecoder.decode(LogoutSession.self, from: newData)
                
                Authentication.sessionId = ""
                Authentication.key = ""
                
                completion()
            } catch {
                completion()
            }
        }
        task.resume()
        
    }
    
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch{
                do{
                    let errorResponse = try JSONDecoder().decode(ClientError.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                }
                catch{
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func postLocation(completion: @escaping (Bool, Error?) -> Void){
        let locationRequest = AddLocationRequest(uniqueKey: Authentication.key, firstName: "John", lastName: "Doe", mapString: Authentication.userPosted.mapString, mediaURL: Authentication.userPosted.mediaURL, latitude: Authentication.userPosted.latitude, longitude: Authentication.userPosted.longitude)
        
        
        print("LocationData = \(Authentication.userPosted)")
        let body = try? JSONEncoder().encode(locationRequest)
        
        var request = URLRequest(url: EndPoint.locations.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            do{
                _ = try JSONDecoder().decode(AddLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(true,nil)
                }
            }
            catch{
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        let data = try? JSONEncoder().encode(body)
        guard let body = data else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { originalData, reponse, error in
            guard let originalData = originalData else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let range = (5..<originalData.count)
            let data = originalData.subdata(in: range)
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch{
                do{
                    let errorResponse = try JSONDecoder().decode(ClientError.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                }
                catch{
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
}
