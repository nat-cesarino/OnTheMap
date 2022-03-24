//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 16/03/22.
//

import Foundation

struct StudentLocation: Codable {
    var firstName: String
    var lastName: String
    var mapString: String
    var uniqueKey: String
    var objectId: String
    var latitude: Double
    var longitude: Double
    var createdAt: String
    var updatedAt: String
    var mediaURL: String
}

struct StudentLocationBody: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
}
