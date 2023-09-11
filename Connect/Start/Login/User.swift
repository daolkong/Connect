//
//  User.swift
//  Connect
//
//  Created by Daol on 2023/09/02.
//

import Foundation

struct User: Codable {
    let email: String
    let fullid: String
    let hastags: String
    let uid: String
    var profileImageURL: String?  // Add this line.
    var uploadedImagesURLs: [String]? // Add this line.
    var friends: [String]
}

extension User {
    static let sample: User = User(
        email: "", fullid: "", hastags: "", uid: "", friends: [])
}


