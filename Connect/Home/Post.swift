//
//  Post.swift
//  Connect
//
//  Created by Daol on 2023/09/18.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: String
    let fullid: String
    let imageUrl: String
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id  // Remove the raw value.
        case fullid
        case imageUrl
        case timestamp
    }
}

extension Post {
    func asDictionary() -> [String: Any] {
        return [
            "fullid": fullid,
            "imageUrl": imageUrl,
            "timestamp": timestamp
        ]
    }
}

