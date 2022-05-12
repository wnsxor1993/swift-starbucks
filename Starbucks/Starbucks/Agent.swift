//
//  Agent.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/12.
//

import Foundation
import Combine

struct Agent {

    static func networkRequest(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}
