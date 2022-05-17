//
//  RecommendItemCollectionViewCell.swift
//  Starbucks
//
//  Created by 최예주 on 2022/05/12.
//

import UIKit

class RecommendItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var rankLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setRank(rank: Int) {
        rankLabel.text = "\(rank+1)"
    }

}
