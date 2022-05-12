//
//  Manager.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/12.
//

import Foundation
import Combine

struct Manager {
    static let subjectData = PassthroughSubject<Codable, Never>()
    
    static func getEventData<T: Codable>(url: URL) -> T?{
        let request = URLRequest(url: url)
        var decodedData: T?

        let event: AnyPublisher<Data, Error> = URLConnector.getRequest(request)
        event.decode(type: T.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { _ in
                print("receiveCompletion")
            }, receiveValue: { data in
                decodedData = data
                subjectData.send(data)
            })
            .cancel()
        
        return decodedData
    }
}
