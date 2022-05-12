//
//  EventDataManager.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/11.
//

import Foundation
import Combine

struct DataManager {

    static let subject = PassthroughSubject<Codable, Never>()
}
