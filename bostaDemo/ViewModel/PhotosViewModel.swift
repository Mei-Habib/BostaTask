//
//  PhotosViewModel.swift
//  bostaDemo
//
//  Created by MacBook on 16/09/2025.
//

import Foundation
import RxSwift

protocol PhotosViewModelType {
    func fetchPhotos(albumId: Int) -> Single<[Photo]>
}
final class PhotosViewModel: PhotosViewModelType {
    private let api: Networkable
    init(api: Networkable = NetworkManager.shared) { self.api = api }
    
    func fetchPhotos(albumId: Int) -> Single<[Photo]> {
        api.fetchPhotos(for: albumId)
    }
}
