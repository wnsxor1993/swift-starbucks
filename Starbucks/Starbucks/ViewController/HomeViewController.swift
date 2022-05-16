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

    private var isPresented = false

    let data = ["9200000002760", "25", "9200000002487", "9300000003067", "9300000003524"]

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showModal), name: Notification.Name("event"), object: EventDataManager.self)

        configureCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc
    func showModal(_ notification: Notification) {
        guard UserDefaults.standard.bool(forKey: "isConfirmed") && !isPresented, let eventData = notification.userInfo?["data"] as? Event else { return }
        showEventModal(data: eventData)
        isPresented = true
    }

    func showEventModal(data: Event) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "EventVC") as? EventViewController else { return }
        nextVC.setEventData(event: data)
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }

    func configureCollectionView() {

        collectionView.delegate = self
        collectionView.dataSource = self

        let nibName = UINib(nibName: "RecommendItemCollectionViewCell", bundle: .main)
        collectionView.register(nibName, forCellWithReuseIdentifier: "ItemCell")

        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.headerId)
        collectionView.collectionViewLayout = compositionLayout()
    }

    func compositionLayout() -> UICollectionViewCompositionalLayout {

        let cellSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: cellSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

        section.boundarySupplementaryItems = [header]

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

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

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.headerId, for: indexPath) as? CollectionHeaderView else { return UICollectionReusableView() }
        return header
    }
 }
