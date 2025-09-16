//
//  ViewController.swift
//  bostaDemo
//
//  Created by MacBook on 14/09/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 2
        return label
    }()

    private let userInfoContainer = UIView()

    private var user: User?
    private var albums: [Album] = []
    let vm = ProfileViewModel()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        title = "Profile"
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        tableView.tableFooterView = UIView()

        configure()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }

    private func configure() {
        let stack = UIStackView(arrangedSubviews: [nameLabel, addressLabel])
        stack.axis = .vertical
        stack.spacing = 6

        userInfoContainer.subviews.forEach { $0.removeFromSuperview() }
        userInfoContainer.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: userInfoContainer.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: userInfoContainer.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: userInfoContainer.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: userInfoContainer.bottomAnchor, constant: -8)
        ])

        let width = view.bounds.width
        userInfoContainer.frame = CGRect(x: 0, y: 0, width: width, height: 1)
        userInfoContainer.setNeedsLayout()
        userInfoContainer.layoutIfNeeded()
        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let height = userInfoContainer.systemLayoutSizeFitting(targetSize).height
        userInfoContainer.frame.size.height = height

        tableView.tableHeaderView = userInfoContainer
    }

    private func refreshInfoHeight() {
        guard let header = tableView.tableHeaderView else { return }
        let width = view.bounds.width
        header.frame.size.width = width
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let target = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let height = header.systemLayoutSizeFitting(target).height
        if header.frame.height != height {
            header.frame.size.height = height
            tableView.tableHeaderView = header
        }
    }
    
    private func bind() {
        vm.fetchUser()
            .observe(on: MainScheduler.instance)
            .do(onSuccess: { [weak self] user in
                self?.nameLabel.text = user.name
                self?.addressLabel.text = user.fullAddress
                self?.refreshInfoHeight()
            })
            .flatMap { [vm] user in
                vm.fetchAlbums(for: user.id)
            }
            .observe(on: MainScheduler.instance) 
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "AlbumCell",
                                         cellType: UITableViewCell.self)) { _, album, cell in
                cell.textLabel?.text = album.title
                cell.textLabel?.numberOfLines = 1
                cell.accessoryType = .none
            }
            .disposed(by: bag)

        tableView.rx.modelSelected(Album.self)
            .withLatestFrom(tableView.rx.itemSelected) { ($0, $1) }
            .subscribe(onNext: { [weak self] (album, indexPath) in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                let vc = PhotosViewController()
                vc.albumId = album.id
                vc.albumTitle = album.title
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
    }
}
