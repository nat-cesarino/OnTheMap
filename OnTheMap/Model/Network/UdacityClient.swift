//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 07/03/22.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
        static var key = ""
        static var objectId = ""
        static var firstName = "Nathalie"
        static var lastName = "Cesarino"
    }
        
    enum Endpoints {
         static let base = "https://onthemap-api.udacity.com/v1"
        
        case udacitySignUp
        case login
        case getStudentLocation
        
        var stringValue: String {
            switch self {
            case .udacitySignUp:
                return "https://auth.udacity.com/sign-up"
            case .login:
                return Endpoints.base + "/session"
            case .getStudentLocation:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
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
    
}
