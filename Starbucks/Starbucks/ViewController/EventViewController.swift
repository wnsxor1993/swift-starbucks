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
        setLabelText()
    }

    @IBAction func touchedConfirmButton(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isConfirmed")
        self.dismiss(animated: true)
    }

    @IBAction func touchedCloseButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    func setLabelText() {
        guard let eventData = fetchEvent.data else { return }
        self.mainLabel.text = eventData.title
        self.periodLabel.text = eventData.range
        self.targetLabel.text = eventData.target
        self.contextLabel.text = eventData.description
        self.eventItemLabel.text = eventData.eventProducts
    }
}
