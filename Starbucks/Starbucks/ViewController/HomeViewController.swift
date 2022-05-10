//
//  HomeViewController.swift
//  Starbucks
//
//  Created by 최예주 on 2022/05/09.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: "isConfirmed") {
            showEventModal()
        }
    }

    func showEventModal() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "EventVC") as? EventViewController else { return }
        self.present(nextVC, animated: true, completion: nil)

    }

}
