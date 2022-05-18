//
//  RecommandProductImage.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/18.
//

import Foundation

struct RecommandProductImage: Codable {
    let file: [ProductImageInfo]?

    struct ProductImageInfo: Codable {
        let filePath: String
        let imageUploadPath: URL

        enum CodingKeys: String, CodingKey {
            case filePath = "file_PATH"
            case imageUploadPath = "img_UPLOAD_PATH"
        }

        var imageUrl: URL {
            imageUploadPath.appendingPathComponent(filePath)
        }
    }
}
