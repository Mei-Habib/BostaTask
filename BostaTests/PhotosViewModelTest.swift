//
//  PhotosViewModelTest.swift
//  BostaTests
//
//  Created by MacBook on 16/09/2025.
//

import XCTest
import RxBlocking
@testable import bostaDemo

final class PhotosViewModelTests: XCTestCase {

    func test_fetchPhotos_forwardsAlbumId_andReturnsData() throws {
        let mock = MockNetwork()
        mock.photosResultByAlbum[10] = .just([
            makePhoto(albumId: 10, id: 100, title: "Beach")
        ])
        let vm = PhotosViewModel(api: mock)

        let photos = try vm.fetchPhotos(albumId: 10).toBlocking().single()

        XCTAssertEqual(mock.fetchPhotosCalledWith, [10]) // param forwarded
        XCTAssertEqual(photos.count, 1)
        XCTAssertEqual(photos.first?.title, "Beach")
    }

    func test_fetchPhotos_propagatesError() {
        enum FakeError: Error { case oops }
        let mock = MockNetwork()
        mock.photosResultByAlbum[10] = .error(FakeError.oops)
        let vm = PhotosViewModel(api: mock)

        XCTAssertThrowsError(try vm.fetchPhotos(albumId: 10).toBlocking().single())
    }
}

