//
//  CollectionHeaderView.swift
//  Starbucks
//
//  Created by 최예주 on 2022/05/12.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    private var titleLabel: UILabel!
    private var timeLabel: UILabel!
    static let headerId = "Header"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        timeLabel.text = ""
    }

    func configureLabel() {
        titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 20)
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        timeLabel = UILabel()
        timeLabel.text = ""
        timeLabel.textColor = .systemGray
        timeLabel.font = .systemFont(ofSize: 12)
        self.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    func setTimeLabel(time: String) {
        titleLabel.text = "이 시간대 인기 메뉴"
        timeLabel.text = time
    }

    func setTitleLabel(text: String) {
        titleLabel.text = text
    }

}
