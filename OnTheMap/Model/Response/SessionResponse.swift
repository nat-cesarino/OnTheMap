//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Nathalie Cesarino on 14/03/22.
//

import Foundation

import Foundation

struct SessionResponse: Codable {
    let account: SessionForAccount
    let session: SessionForSession
}

struct SessionForAccount: Codable {
    let registered: Bool
    let key: String
}

struct SessionForSession: Codable {
    let id: String
    let expiration: String
}
