//
//  Manager.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/12.
//

import Foundation
import Combine

struct JSONConverter<T: Codable> {

    static func getEventData(url: URL) {
        let request = URLRequest(url: url)

        let event: AnyPublisher<Data, Error> = URLConnector.getRequest(request)
        event.decode(type: T.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { _ in

            }, receiveValue: { data in
                DataManager.subject.send(data)
            })
            .cancel()
    }

    static func getHomeData(url: URLRequest, handler: @escaping (T) -> Void) {

        let event: AnyPublisher<Data, Error> = URLConnector.getRequest(url)
        event.decode(type: T.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { _ in

            }, receiveValue: { data in
                handler(data)
            })
            .cancel()
    }
}
