//
//  MockNetwork.swift
//  BostaTests
//
//  Created by MacBook on 16/09/2025.
//

import RxSwift
@testable import bostaDemo

final class MockNetwork: Networkable {
  
    private(set) var fetchUsersCalled = false
    private(set) var fetchAlbumsCalledWith: [Int] = []
    private(set) var fetchPhotosCalledWith: [Int] = []

   
    var usersResult: Single<[User]> = .just([])
    var albumsResultByUser: [Int: Single<[Album]>] = [:]
    var photosResultByAlbum: [Int: Single<[Photo]>] = [:]

    func fetchUsers() -> Single<[User]> {
        fetchUsersCalled = true
        return usersResult
    }

    func fetchAlbums(for userId: Int) -> Single<[Album]> {
        fetchAlbumsCalledWith.append(userId)
        return albumsResultByUser[userId] ?? .just([])
    }

    func fetchPhotos(for albumId: Int) -> Single<[Photo]> {
        fetchPhotosCalledWith.append(albumId)
        return photosResultByAlbum[albumId] ?? .just([])
    }
}
