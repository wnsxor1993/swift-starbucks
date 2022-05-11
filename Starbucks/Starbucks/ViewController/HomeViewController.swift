//
//  HomeViewController.swift
//  Starbucks
//
//  Created by 최예주 on 2022/05/09.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    private var isPresented = false

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showModal), name: Notification.Name("event"), object: EventDataManager.self)
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
