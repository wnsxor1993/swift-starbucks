//
//  whatsNewHeaderView.swift
//  Starbucks
//
//  Created by 최예주 on 2022/05/17.
//

import UIKit

class whatsNewHeaderView: UICollectionReusableView {

    private var seeAllButton: UIButton!
    static let headerId = "WhatsNewHeader"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configureLayout() {
        seeAllButton = UIButton()
        seeAllButton.setTitle("See all", for: .normal)
        seeAllButton.setTitleColor(.systemGreen, for: .normal)
        self.addSubview(seeAllButton)
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        seeAllButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        seeAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        seeAllButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        seeAllButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        seeAllButton.widthAnchor.constraint(equalToConstant: 70).isActive = true

    }
}
