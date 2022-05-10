//
//  Event.swift
//  Starbucks
//
//  Created by 최예주 on 2022/05/10.
//

import Foundation

struct Event: Codable {

    let title: String
    let range: String
    let target: String
    let description: String
    let eventProducts: String

    enum CodingKeys: String, CodingKey {
        case title
        case range
        case target
        case description
        case eventProducts = "event-products"
    }

}
