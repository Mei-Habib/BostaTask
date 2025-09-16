//
//  PhotoCell.swift
//  bostaDemo
//
//  Created by MacBook on 15/09/2025.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    static let reuseID = "PhotoCell"

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(white: 1.0, alpha: 0.65)
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }

    func configure(with photo: Photo) {
        if let spec = parsePhotoURL(photo.url),
           let color = UIColor(hex: spec.hex) {
            contentView.backgroundColor = color
            label.text = "\(spec.size) x \(spec.size)"
        } else if let spec = parsePhotoURL(photo.url),
                  let color = UIColor(hex: spec.hex) {
            contentView.backgroundColor = color
            label.text = "\(spec.size) x \(spec.size)"
        } else {
            contentView.backgroundColor = UIColor(white: 0.9, alpha: 1)
            label.text = ""
        }
    }
}

struct PhotoSpecs { let size: Int; let hex: String }

func parsePhotoURL(_ urlString: String) -> PhotoSpecs? {
    guard let url = URL(string: urlString) else { return nil }
    let comps = url.path.split(separator: "/")
    guard comps.count >= 2, let size = Int(comps[0]) else { return nil }
    let hex  = String(comps[1])
    
    return PhotoSpecs(size: size, hex: hex)
}


extension UIColor {
    convenience init?(hex: String) {
        var s = hex
        guard s.count == 3 || s.count == 6 else { return nil }
        if s.count == 3 { s = s.map { "\($0)\($0)" }.joined() }
        var rgb: UInt64 = 0
        guard Scanner(string: s).scanHexInt64(&rgb) else { return nil }
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: 1
        )
    }
}


