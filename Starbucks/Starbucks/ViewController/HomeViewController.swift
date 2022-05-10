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
        // requestAPI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showModal()
    }

    func showModal() {
        guard UserDefaults.standard.bool(forKey: "isConfirmed") && !isPresented else { return }

        showEventModal()
        isPresented = true
    }

    func showEventModal() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "EventVC") as? EventViewController else { return }
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }

    func requestAPI() {
        guard let url = URL(string: "https://public.codesquad.kr/jk/boostcamp/starbuckst-loading.json") else { return }

        let publisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Event.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    print("failed with \(err)")
                } else {
                    print("Receive completion \(completion)")
                }
            }, receiveValue: { object in
                print(object)
            })
    }
}
