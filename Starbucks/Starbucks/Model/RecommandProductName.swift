//
//  Products.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/17.
//

import Foundation

struct RecommandProductName: Codable {
    let view: Detail?

    struct Detail: Codable {
        let productName: String

        enum CodingKeys: String, CodingKey {
            case productName = "product_NM"
        }
    }
}
