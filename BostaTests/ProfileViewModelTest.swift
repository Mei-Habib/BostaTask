//
//  profileViewModelTest.swift
//  BostaTests
//
//  Created by MacBook on 16/09/2025.
//

import XCTest
import RxBlocking
@testable import bostaDemo

final class ProfileViewModelTests: XCTestCase {

    func test_fetchUser_returnsSingleUser_andCallsNetwork() throws {
        let mock = MockNetwork()
        let expected = makeUser(id: 42, name: "Mei")
        mock.usersResult = .just([expected])
        let vm = ProfileViewModel(api: mock)

        let user = try vm.fetchUser().toBlocking().single()

        XCTAssertTrue(mock.fetchUsersCalled)
        XCTAssertEqual(user.id, 42)
        XCTAssertEqual(user.name, "Mei")
    }

    func test_fetchUser_errors_whenAPIReturnsEmptyArray() {
        let mock = MockNetwork()
        mock.usersResult = .just([])
        let vm = ProfileViewModel(api: mock)

        XCTAssertThrowsError(try vm.fetchUser().toBlocking().single())
    }

    func test_fetchAlbums_forwardsUserId_andReturnsData() throws {
        let mock = MockNetwork()
        mock.albumsResultByUser[7] = .just([
            makeAlbum(userId: 7, id: 1, title: "A"),
            makeAlbum(userId: 7, id: 2, title: "B")
        ])
        let vm = ProfileViewModel(api: mock)

        let albums = try vm.fetchAlbums(for: 7).toBlocking().single()

        XCTAssertEqual(mock.fetchAlbumsCalledWith, [7])
        XCTAssertEqual(albums.count, 2)
        XCTAssertEqual(albums.first?.title, "A")
    }
}

