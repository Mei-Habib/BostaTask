//
//  SecondViewController.swift
//  bostaDemo
//
//  Created by MacBook on 15/09/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class PhotosViewController: UIViewController {

    var albumId: Int!
    var albumTitle: String = ""
    
    private let bag = DisposeBag()
    private let vm  = PhotosViewModel()

    private var allPhotos: [Photo] = []
    private var filtered: [Photo] = []

    private lazy var collectionView: UICollectionView = {
        let layout = Self.makeLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.alwaysBounceVertical = true
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseID)
        return cv
    }()

    private lazy var searchController: UISearchController = {
        let s = UISearchController(searchResultsController: nil)
        s.searchBar.placeholder = "Search in images.."
        s.obscuresBackgroundDuringPresentation = false
        return s
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = albumTitle
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }

    private func bind() {
        let photos = vm.fetchPhotos(albumId: albumId)
            .asObservable()
            .share(replay: 1)

        let query = searchController.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .startWith("")

        let filtered = Observable.combineLatest(photos, query) { items, q -> [Photo] in
            guard !q.isEmpty else { return items }
            return items.filter { $0.title.range(of: q, options: .caseInsensitive) != nil }
        }
        .observe(on: MainScheduler.instance)
        .share(replay: 1)

        filtered
            .bind(to: collectionView.rx.items(
                cellIdentifier: PhotoCell.reuseID,
                cellType: PhotoCell.self
            )) { _, photo, cell in
                cell.configure(with: photo)
            }
            .disposed(by: bag)

        collectionView.rx.modelSelected(Photo.self)
            .withLatestFrom(collectionView.rx.itemSelected) { ($0, $1) }
            .subscribe(onNext: { [weak self] (photo, indexPath) in
                guard let self = self else { return }
                self.collectionView.deselectItem(at: indexPath, animated: true)
                if let cell = self.collectionView.cellForItem(at: indexPath) as? PhotoCell {
                    let snapshot = cell.snapshotImage()
                    let viewer = ImageViewerViewController()
                    viewer.image = snapshot
                    self.navigationController?.pushViewController(viewer, animated: true)
                }
            })
            .disposed(by: bag)
    }

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/3.0),
                                               heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1.0/3.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(0)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = .zero

        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension UIView {
    func snapshotImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { ctx in
            layer.render(in: ctx.cgContext)
        }
    }
}

