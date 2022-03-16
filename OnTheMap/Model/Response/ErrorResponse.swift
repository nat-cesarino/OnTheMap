//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 14/03/22.
//

import Foundation

struct ErrorResponse: Codable, Error {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case statusMessage = "error"
    }
}
