//
//  AlbumCell.swift
//  bostaDemo
//
//  Created by MacBook on 14/09/2025.
//

import UIKit

class AlbumCell: UITableViewCell {
    
    @IBOutlet weak var albumTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
