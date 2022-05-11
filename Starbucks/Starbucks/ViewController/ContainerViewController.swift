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
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate

    }

}
