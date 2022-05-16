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

    private var eventData: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelText()
        setButtonLayout()
    }

    @IBAction func touchedConfirmButton(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "showModal")
        self.dismiss(animated: true)
    }

    @IBAction func touchedCloseButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    func setEventData(event data: Event) {
        self.eventData = data
    }
}

private extension EventViewController {

    func setLabelText() {
        guard let eventData = self.eventData else { return }
        self.mainLabel.text = eventData.title
        self.periodLabel.text = eventData.range
        self.targetLabel.text = eventData.target

        if #available(iOS 15, *) {
            do {
                let str = try AttributedString(markdown: eventData.description)
                self.contextLabel.attributedText = NSAttributedString(str)
            } catch {

            }
        } else {
            self.contextLabel.text = eventData.description
        }
        self.eventItemLabel.text = eventData.eventProducts
    }

    func setButtonLayout() {
        self.confirmButton.layer.borderWidth = 1
        self.confirmButton.layer.borderColor = UIColor.systemGreen.cgColor
        self.confirmButton.layer.cornerRadius = 17
        self.closeButton.layer.cornerRadius = 17
    }
}
