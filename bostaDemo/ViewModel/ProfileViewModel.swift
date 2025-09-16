//
//  ProfileViewModel.swift
//  bostaDemo
//
//  Created by MacBook on 16/09/2025.
//

import Foundation
import RxSwift

protocol ProfileViewModelProtocol {
    func fetchUser() -> Single<User>
    func fetchAlbums(for userId: Int) -> Single<[Album]>
}

final class ProfileViewModel: ProfileViewModelProtocol {
    private let api: Networkable
    init(api: Networkable = NetworkManager.shared) { self.api = api }

    func fetchUser() -> Single<User> {
        api.fetchUsers()
            .map { users in
                guard let user = users.randomElement() else {
                    throw NSError(domain: "app.profile", code: -1,
                                  userInfo: [NSLocalizedDescriptionKey: "No users"])
                }
                return user
            }
    }

    func fetchAlbums(for userId: Int) -> Single<[Album]> {
        api.fetchAlbums(for: userId)
    }
}
