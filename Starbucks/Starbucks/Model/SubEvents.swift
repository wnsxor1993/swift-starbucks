//
//  SubEvents.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/19.
//

import Foundation

struct SubEvents: Codable {
    let list: [Promotion]

    struct Promotion: Codable {
        let title: String
        let imageUploadPath: URL
        let thumbnail: String

        enum CodingKeys: String, CodingKey {
            case title
            case imageUploadPath = "img_UPLOAD_PATH"
            case thumbnail = "mob_THUM"
        }
    }
}
