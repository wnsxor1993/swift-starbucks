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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func addNotification() {
        DataManager.subject
            .sink(receiveValue: { data in
                guard let event = data as? Event else { return }
                self.showModal(eventData: event)
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
