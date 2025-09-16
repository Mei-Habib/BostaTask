//
//  Photo.swift
//  bostaDemo
//
//  Created by MacBook on 15/09/2025.
//

import Foundation

struct Photo : Decodable, Identifiable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
}
