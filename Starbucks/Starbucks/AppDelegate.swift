//
//  AppDelegate.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/09.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private(set) var eventData: Event?
    private(set) var data: fetchEvent = fetchEvent()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        guard let url = URL(string: "https://public.codesquad.kr/jk/boostcamp/starbuckst-loading.json") else { return true }

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
                self.eventData = object
                self.data.setData(eventData: object)

            })

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
