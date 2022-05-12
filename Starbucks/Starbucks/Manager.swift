//
//  Manager.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/12.
//

import Foundation
import Combine

class Manager {
    static let notifyEvent = PassthroughSubject<Event, Never>()
}

extension Manager {
    static func getEventData(url: URL) {
        let request = URLRequest(url: url)

        let event: AnyPublisher<Data, Error> = Agent.networkRequest(request)
        event.decode(type: Event.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { _ in
                print("receiveCompletion")
            }, receiveValue: { event in
                notifyEvent.send(event)
            })
            .cancel()
    }
}
