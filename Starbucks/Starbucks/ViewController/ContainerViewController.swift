//
//  ViewController.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/09.
//

import UIKit
import Combine

class ContainerViewController: UITabBarController {

    private var isPresented = false
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotification()
    }

    func addNotification() {
        Manager.notifyEvent
            .sink(receiveValue: { data in
                self.showModal(eventData: data)
            })
            .store(in: &cancellables)
    }

    func showModal(eventData: Event) {
        guard UserDefaults.standard.bool(forKey: "isConfirmed") && !isPresented else { return }
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
