//
//  User.swift
//  ARBostaTask
//
//  Created by Adham Raouf on 14/12/2024.
//

import Foundation



struct User: Decodable {
    let id: Int
    let name: String
    let address: Address
}

struct Address: Decodable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    
    var fullAddress: String {
        return "\(street), \(suite), \(city), \(zipcode)"
    }
}
