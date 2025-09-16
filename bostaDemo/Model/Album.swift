//
//  Album.swift
//  bostaDemo
//
//  Created by MacBook on 14/09/2025.
//

import Foundation

struct Album : Decodable, Identifiable{
    let userId: Int
    let id: Int
    let title: String
}
