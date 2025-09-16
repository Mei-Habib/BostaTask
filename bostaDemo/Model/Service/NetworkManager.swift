//
//  NetworkManager.swift
//  bostaDemo
//
//  Created by MacBook on 15/09/2025.
//

import Foundation
import Moya
import RxSwift
import RxMoya

protocol Networkable {
    func fetchUsers() -> Single<[User]>
    func fetchAlbums(for userId: Int) -> Single<[Album]>
    func fetchPhotos(for albumId: Int) -> Single<[Photo]>
}

final class NetworkManager: Networkable {
    static let shared = NetworkManager()

    private let provider: MoyaProvider<JSONPlaceholder>

    private init() {
       self.provider = MoyaProvider<JSONPlaceholder>(
           session: Self.session,
           plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
       )
    }

    internal init(provider: MoyaProvider<JSONPlaceholder>) {
       self.provider = provider
    }
    
    private static let session: Session = {
        #if targetEnvironment(simulator)
        let config = URLSessionConfiguration.ephemeral
        #else
        let config = URLSessionConfiguration.default
        #endif
        return Session(configuration: config)
    }()
    
    func fetchUsers() -> Single<[User]> {
        provider.rx.request(.users)
            .filterSuccessfulStatusCodes()
            .map([User].self)
    }
    
    func fetchAlbums(for userId: Int) -> Single<[Album]> {
        provider.rx.request(.albums(userId: userId))
            .filterSuccessfulStatusCodes()
            .map([Album].self)
    }
    
    func fetchPhotos(for albumId: Int) -> Single<[Photo]> {
        provider.rx.request(.photos(albumId: albumId))
            .filterSuccessfulStatusCodes()
            .map([Photo].self)
    }
}
