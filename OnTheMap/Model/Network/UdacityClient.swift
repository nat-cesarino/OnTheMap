//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 07/03/22.
//

import Foundation
import UIKit
import MapKit

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
        static var uniqueKey = ""
        static var objectId = ""
        static var firstName = ""
        static var lastName = ""
    }
        
    enum Endpoints {
         static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case getStudentLocation
        case postLocation
        case logout
        case getPublicData
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "/session"
            case .getStudentLocation:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .postLocation:
                return Endpoints.base + "/StudentLocation"
            case .logout:
                return Endpoints.base + "/session"
            case .getPublicData:
                return Endpoints.base + "/users" + "/\(Auth.objectId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // MARK: Methods
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: ["username" : "\(username)", "password" : "\(password)"])
        RequestHelpers.taskForPostRequest(url: Endpoints.login.url, responseType: SessionResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.objectId = response.account.key
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
    
    class func getStudentLocation(completion: @escaping ([StudentLocation], Error?) -> Void) {
        RequestHelpers.taskForGetRequest(url: Endpoints.getStudentLocation.url, responseT: AllStudentsLocationResponse.self) { response, error in
            if let response =  response {
                DispatchQueue.main.async {
                    completion(response.results, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    class func getPublicData(completionHandler: @escaping (String?, String?, Error?) -> Void){
        RequestHelpers.taskForGetRequest(url: Endpoints.getPublicData.url, responseT: PublicUserDataResponse.self) { response, error in
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                Auth.uniqueKey = response.key
                DispatchQueue.main.async {
                    completionHandler(response.firstName,response.lastName, nil)
                }
                print(response)
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil, nil, error)
                }
            }
        }
    }
    
    class func postLocation(studentLocation: MKAnnotation, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = StudentLocationBody(uniqueKey: Auth.uniqueKey, firstName: Auth.firstName, lastName: Auth.lastName, latitude: Float(studentLocation.coordinate.latitude), longitude: Float(studentLocation.coordinate.longitude), mapString: ((studentLocation.title) ?? "")!, mediaURL: mediaURL)
        RequestHelpers.taskForPostRequest(url: Endpoints.postLocation.url, responseType: PostLocationResponse.self, body: body) { response, error in
            if let response = response {
                Auth.objectId = response.objectId
                completion(true, nil)
            } else {
                print(error)
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {xsrfCookie = cookie}
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            Auth.sessionId = ""
            Auth.objectId = ""
            DispatchQueue.main.async {
                completion()
            }
        }
        task.resume()
    }
}
