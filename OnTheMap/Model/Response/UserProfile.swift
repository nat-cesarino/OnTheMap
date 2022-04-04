//
//  UserProfile.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 29/03/22.
//

import Foundation

struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}
