//
//  PublicUserDataResponse.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 29/03/22.
//

import Foundation

struct PublicUserDataResponse: Codable {
    let lastName: String
    let firstName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case key
    }
}
