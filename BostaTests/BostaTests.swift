//
//  BostaTests.swift
//  BostaTests
//
//  Created by MacBook on 16/09/2025.
//

import Testing
@testable import bostaDemo

func makeUser(id: Int = 1, name: String = "Alice") -> User {
    User(
        id: id,
        name: name,
        address: Address(street: "S", suite: "Apt 1", city: "Berlin", zipcode: "10115")
    )
}

func makeAlbum(userId: Int = 1, id: Int = 10, title: String = "Summer") -> Album {
    Album(userId: userId, id: id, title: title)
}

func makePhoto(albumId: Int = 10, id: Int = 100, title: String = "Beach", url: String = "https://x/y.jpg") -> Photo {
    Photo(albumId: albumId, id: id, title: title, url: url)
}
