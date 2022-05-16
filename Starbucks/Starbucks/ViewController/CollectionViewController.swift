//
//  CollectionViewController.swift
//  Starbucks
//
//  Created by 최예주 on 2022/05/12.
//

import UIKit

class CollectionViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    let data = ["9200000002760", "25", "9200000002487", "9300000003067", "9300000003524"]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        registerCell()
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.headerId)
        collectionView.collectionViewLayout = compositionLayout()

    }
    func registerCell() {
        let nibName = UINib(nibName: "RecommendItemCollectionViewCell", bundle: .main)
        collectionView.register(nibName, forCellWithReuseIdentifier: "ItemCell")
    }

    func compositionLayout() -> UICollectionViewCompositionalLayout {

        let cellSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8))
        let item = NSCollectionLayoutItem(layoutSize: cellSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: data.count)

        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.2))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

}
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? RecommendItemCollectionViewCell else { return UICollectionViewCell()}

        cell.itemImageView.image = UIImage(systemName: "x.circle")
        cell.nameLabel.text = data[indexPath.item]

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.headerId, for: indexPath) as? CollectionHeaderView else { return UICollectionReusableView() }

        return header
    }

}

 extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: 50, height: 20)
    }

 }
