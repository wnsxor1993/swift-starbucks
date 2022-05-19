//
//  MainEventCell.swift
//  Starbucks
//
//  Created by 최예주 on 2022/05/17.
//

import UIKit

class MainEventCell: UICollectionViewCell {

    @IBOutlet var mainImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setImage(_ image: UIImage?) {
        guard let image = image else {
            return
        }
        mainImageView.image = image

    }

}
