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

    let homeDataManager = HomeViewDataManager()
    private var cancellables = Set<AnyCancellable>()

    private var mainEventImage: UIImage?
    private var subEventsCollection = [(String, UIImage)]()

    let data = ["아이스 카페 아메리카노", "아이스 카페 라떼", "아이스 자몽 허니 블랙티", "클래식 스콘", "미니 클래식 스콘"]

    enum Section: Int, CaseIterable {
        case recommendMenu = 0
        case mainEvent
        case whatsNew
        case popularMenu

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        postAllDetailDatas()
        configureCollectionView()
    }

    func postAllDetailDatas() {
        self.homeDataManager.recommendReload
            .sink(receiveValue: { value in
                if value {
                    self.collectionView.reloadSections(IndexSet(integer: Section.recommendMenu.rawValue))
                }
            })
            .store(in: &cancellables)

        self.homeDataManager.mainEventReload
            .sink(receiveValue: { data in
                let image = UIImage(data: data)
                self.mainEventImage = image
                self.collectionView.reloadSections(IndexSet(integer: Section.mainEvent.rawValue))
            })
            .store(in: &cancellables)

        self.homeDataManager.subEventReload
            .sink(receiveValue: { data in
                guard let image = UIImage(data: data.1) else { return }
                self.subEventsCollection.append((data.0, image))
                self.collectionView.reloadSections(IndexSet(integer: Section.whatsNew.rawValue))
            })
            .store(in: &cancellables)

        self.homeDataManager.entireData
            .sink { data in
                UserDefaults.standard.set(data.displayName, forKey: "userName")
                self.collectionView.reloadSections(IndexSet(integer: Section.recommendMenu.rawValue))
            }.store(in: &cancellables)
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

            guard let section = Section(rawValue: section) else { return nil }
            switch section {
            case .recommendMenu:
                let cellSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: cellSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous

                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

                section.boundarySupplementaryItems = [header]
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15.0, bottom: 30, trailing: 0)

                return section

            case .mainEvent:
                let cellSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: cellSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(self.calculateMainEventImageHeight()))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15.0, bottom: 30, trailing: 15.0)

                return section

            case .whatsNew:
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

            case .popularMenu:
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

// MARK: Inner using function

private extension HomeViewController {
    func calculateMainEventImageHeight() -> CGFloat {
        guard let height = self.mainEventImage?.size.height, let width = self.mainEventImage?.size.width else { return 0 }

        let ratio = height / width
        let realHeight = self.view.frame.width * ratio

        return realHeight
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let section = Section(rawValue: section) else { return 0 }

        switch section {
        case .recommendMenu:
            if homeDataManager.recommandImage.count > homeDataManager.recommandInfo.count {
                return homeDataManager.recommandInfo.count
            } else {
                return homeDataManager.recommandImage.count
            }

        case .mainEvent:
            return 1

        case .whatsNew:
            return self.subEventsCollection.count

        case .popularMenu:
            return data.count

        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
        switch section {

        case .recommendMenu:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? RecommendItemCollectionViewCell else { return UICollectionViewCell()}

            let sequence = homeDataManager.yourProductsSerial[indexPath.item]
            let text = homeDataManager.recommandInfo[sequence]
            let imgData = homeDataManager.recommandImage[sequence] ?? Data()

            cell.itemImageView.image = UIImage(data: imgData)
            cell.nameLabel.text = text

            return cell
        case .mainEvent:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainEventCell", for: indexPath) as? MainEventCell else { return UICollectionViewCell() }

            cell.mainImageView.image = mainEventImage

            return cell

        case .whatsNew:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WhatsNewCell", for: indexPath) as? WhatsNewCell else { return UICollectionViewCell() }

            cell.imageView.image = self.subEventsCollection[indexPath.item].1
            cell.titleLabel.text = self.subEventsCollection[indexPath.item].0
            cell.contentLabel.text = "준택이에게 돌체라떼 평생 무료 이용권을 드립니다^0^"

            return cell

        case .popularMenu:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? RecommendItemCollectionViewCell else { return UICollectionViewCell()}

            cell.itemImageView.image = UIImage(systemName: "x.circle")
            cell.nameLabel.text = data[indexPath.item]
            cell.setRank(rank: indexPath.item)

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let section = Section(rawValue: indexPath.section) else { return UICollectionReusableView() }

        switch section {

        case .recommendMenu:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.headerId, for: indexPath) as? CollectionHeaderView else { return UICollectionReusableView() }
            let userName = (UserDefaults.standard.string(forKey: "userName") ?? "사용자") as String
            header.setTitleLabel(name: userName)
            return header

        case .whatsNew:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: whatsNewHeaderView.headerId, for: indexPath) as? whatsNewHeaderView else { return UICollectionReusableView() }
            return header

        case .popularMenu:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderView.headerId, for: indexPath) as? CollectionHeaderView else { return UICollectionReusableView() }
            header.setTimeLabel(time: "주중 오후 4시 기준")
            return header

        default:
            return UICollectionReusableView()
        }
    }
 }
