//
//  User.swift
//  bostaDemo
//
//  Created by MacBook on 14/09/2025.
//

import Foundation

struct User: Decodable, Identifiable {
    let id: Int
    let name: String
    let address: Address
    var fullAddress: String {
        "\(address.street), \(address.suite), \(address.city), \(address.zipcode)"
    }
}

struct Address: Decodable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    
}
