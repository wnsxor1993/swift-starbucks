//
//  CollectionHeaderView.swift
//  Starbucks
//
//  Created by 최예주 on 2022/05/12.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    private var titleLabel: UILabel!
    static let headerId = "Header"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configureLabel() {
        self.backgroundColor = .blue
        titleLabel = UILabel()
        titleLabel.text = "준택이를 위한 추천메뉴"
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

    }

}
