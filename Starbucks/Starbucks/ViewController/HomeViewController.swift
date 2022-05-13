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
    @IBOutlet var tableViewCell: TableViewCell!
    private var isPresented = false

    let menuCollectionVC = CollectionViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showModal), name: Notification.Name("event"), object: EventDataManager.self)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.contentView.addSubview(menuCollectionVC.view)

        menuCollectionVC.view.translatesAutoresizingMaskIntoConstraints = false
        menuCollectionVC.view.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor).isActive = true
        menuCollectionVC.view.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor).isActive = true
        menuCollectionVC.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
        menuCollectionVC.view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true

        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

}
