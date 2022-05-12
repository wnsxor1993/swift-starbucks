//
//  HomeViewController.swift
//  Starbucks
//
//  Created by 최예주 on 2022/05/09.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    private var isPresented = false

//    let collectionViewNib = UINib(nibName: "CollectionViewController", bundle: .main)
    let menuCollectionVC = CollectionViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showModal), name: Notification.Name("event"), object: EventDataManager.self)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "tableCell")

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
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as? TableViewCell else { return UITableViewCell()}
        cell.contentView.addSubview(menuCollectionVC.view)
        return cell

    }

}
