//
//  Post.swift
//  Connect
//
//  Created by Daol on 2023/09/18.
//

//
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Post: Codable, Identifiable {
    var id: String?
    let userId: String
    let imageUrl: String
    let timestamp: Timestamp 
    var tag: String?
    var likeCount: Int
    
    enum CodingKeys: String, CodingKey {
        case userId
        case imageUrl
        case timestamp
        case tag
        case likeCount
    }
}

extension Post {
    func asDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "imageUrl": imageUrl,
            "timestamp": timestamp as Any,
            "tag": tag as Any,
            "likeCount": likeCount
        ]
    }
}


