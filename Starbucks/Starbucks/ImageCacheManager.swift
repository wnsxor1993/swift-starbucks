//
//  ImageCacheManager.swift
//  Starbucks
//
//  Created by 최예주 on 2022/05/19.
//

import Foundation

class ImageCacheManager {
    static let shared = NSCache<NSString, NSData>()
    static let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first

    private init() { }

    static func loadCachedImage(url: URL) -> Data? {

        if let imageData = ImageCacheManager.shared.object(forKey: NSString(string: "\(url)")) { return imageData as Data }

        guard let pathUrl = ImageCacheManager.path else { return nil }

        let fileManager = FileManager()
        var filePath = URL(fileURLWithPath: pathUrl)
        filePath.appendPathComponent(url.lastPathComponent)

        guard let fileAtPath = ImageCacheManager.path else { return nil }
        if fileManager.fileExists(atPath: fileAtPath) {
            let imageData = try? Data(contentsOf: filePath)
            return imageData
        } else {
            return nil

        }

    }

}
