//
//  ViewController.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/09.
//

import UIKit

class ContainerViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showEventModal() {

    }

    func checkLastLogin() {
        let now = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let past = formatter.date(from: "2021/05/10 22:31")

        let diff = Calendar.current.dateComponents([.day], from: now, to: past ?? Date())
        if diff.day == 0 {
            // UserDefault 값 확인
            UserDefaults.standard.set(now, forKey: "lastLogin")
        } else {
            }
    }

}
