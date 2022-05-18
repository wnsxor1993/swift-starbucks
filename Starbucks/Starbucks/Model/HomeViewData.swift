//
//  HomeViewData.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/17.
//

import Foundation

struct HomeViewData: Codable {

    let displayName: String
    let yourRecommand: Recommand
    let mainEvent: MainEvent
    let nowRecommand: Recommand

    struct MainEvent: Codable {
        let imgUPLOADPATH: String
        let mobTHUM: String

        enum CodingKeys: String, CodingKey {
            case imgUPLOADPATH = "img_UPLOAD_PATH"
            case mobTHUM = "mob_THUM"
        }
    }

    struct Recommand: Codable {
        let products: [String]
    }

    enum CodingKeys: String, CodingKey {
        case displayName = "display-name"
        case yourRecommand = "your-recommand"
        case mainEvent = "main-event"
        case nowRecommand = "now-recommand"
    }
}
