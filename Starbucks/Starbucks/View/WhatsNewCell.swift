//
//  WhatsNewCell.swift
//  Starbucks
//
//  Created by 최예주 on 2022/05/17.
//

import UIKit

class WhatsNewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
    }

}
