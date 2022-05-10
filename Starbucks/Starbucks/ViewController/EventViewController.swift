//
//  EventViewController.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/10.
//

import UIKit

class EventViewController: UIViewController {
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var contextLabel: UILabel!
    @IBOutlet weak var eventItemLabel: UILabel!

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        observeNotifications()
        checkForNotificationAtLaunch()

    }

    @IBAction func touchedConfirmButton(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isConfirmed")
        self.dismiss(animated: true)
    }

    @IBAction func touchedCloseButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

private extension EventViewController {
    func observeNotifications() {
        NotificationCenter.default.addObserver(forName: Notification.Name("eventData"), object: nil, queue: OperationQueue.main) { (data) in
            guard let eventData = data.object as? Event else { return }
            self.processNotification(eventData: eventData)
        }
    }

    func checkForNotificationAtLaunch() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        if let notificationAtLaunch = appDelegate.remoteNotificationAtLunch, let notification = notificationAtLaunch["eventData"] as? Event {
            self.processNotification(eventData: notification)
        }
    }

    private func processNotification(eventData: Event) {
        self.mainLabel.text = eventData.title
        self.periodLabel.text = eventData.range
        self.targetLabel.text = eventData.target
        self.contextLabel.text = eventData.description
        self.eventItemLabel.text = eventData.eventProducts
    }
}
