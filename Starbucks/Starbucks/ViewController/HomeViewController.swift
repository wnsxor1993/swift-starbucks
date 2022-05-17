//
//  HomeViewController.swift
//  Starbucks
//
//  Created by 최예주 on 2022/05/09.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!

    let data = ["아이스 카페 아메리카노", "아이스 카페 라떼", "아이스 자몽 허니 블랙티", "클래식 스콘", "미니 클래식 스콘"]

    enum Section: Int {
        case recommendMenu = 0
        case mainEvent
        case whatsNew
        case popularMenu

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    func configureCollectionView() {

        collectionView.delegate = self
        collectionView.dataSource = self

        let itemNib = UINib(nibName: "RecommendItemCollectionViewCell", bundle: .main)
        let mainEventNib = UINib(nibName: "MainEventCell", bundle: .main)
        let whatsNewNib = UINib(nibName: "WhatsNewCell", bundle: .main)

        collectionView.register(itemNib, forCellWithReuseIdentifier: "ItemCell")
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.headerId)
        collectionView.register(mainEventNib, forCellWithReuseIdentifier: "MainEventCell")
        collectionView.register(whatsNewNib, forCellWithReuseIdentifier: "WhatsNewCell")
        collectionView.register(whatsNewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: whatsNewHeaderView.headerId)

        collectionView.collectionViewLayout = compositionLayout()
    }

    func compositionLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            switch section {
            case Section.recommendMenu.rawValue:
                let cellSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: cellSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous

                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

                section.boundarySupplementaryItems = [header]
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15.0, bottom: 30, trailing: 0)

                return section

            case Section.mainEvent.rawValue:
                let cellSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: cellSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15.0, bottom: 30, trailing: 15.0)
                return section

            case Section.whatsNew.rawValue:
                let cellSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: cellSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous

                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50.0))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
                section.boundarySupplementaryItems = [header]

                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15.0, bottom: 30, trailing: 0)

                return section

            default:
                let cellSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: cellSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15.0)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous

                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

                section.boundarySupplementaryItems = [header]
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15.0, bottom: 30, trailing: 0)

                return section

            }
        }
        return layout
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Section.recommendMenu.rawValue:
            return data.count

        case Section.mainEvent.rawValue:
            return 1

        case Section.whatsNew.rawValue:
            return 5

        case Section.popularMenu.rawValue:
            return data.count

        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {

        case Section.recommendMenu.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? RecommendItemCollectionViewCell else { return UICollectionViewCell()}

            cell.itemImageView.image = UIImage(systemName: "x.circle")
            cell.nameLabel.text = data[indexPath.item]

            return cell
        case Section.mainEvent.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainEventCell", for: indexPath) as? MainEventCell else { return UICollectionViewCell() }

            cell.mainImageView.image = UIImage(named: "starbucksEventImage")
            return cell

        case Section.whatsNew.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhatsNewCell", for: indexPath) as? WhatsNewCell else { return UICollectionViewCell() }

            cell.imageView.image = UIImage(named: "starbucksEventImage")
            cell.titleLabel.text = "돌체라떼 Free for 준택"
            cell.contentLabel.text = "준택이에게 돌체라떼 평생 무료 이용권을 드립니다^0^"

            return cell

        case Section.popularMenu.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? RecommendItemCollectionViewCell else { return UICollectionViewCell()}

            cell.itemImageView.image = UIImage(systemName: "x.circle")
            cell.nameLabel.text = data[indexPath.item]
            cell.setRank(rank: indexPath.item)

            return cell

        default:
            return UICollectionViewCell()

        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch indexPath.section {

        case Section.recommendMenu.rawValue:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.headerId, for: indexPath) as? CollectionHeaderView else { return UICollectionReusableView() }
            return header

        case Section.whatsNew.rawValue:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: whatsNewHeaderView.headerId, for: indexPath) as? whatsNewHeaderView else { return UICollectionReusableView() }
            return header

        case Section.popularMenu.rawValue:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.headerId, for: indexPath) as? CollectionHeaderView else { return UICollectionReusableView() }
            header.setTimeLabel(time: "주중 오후 4시 기준")
            return header

        default:
            return UICollectionReusableView()

        }
    }
 }
