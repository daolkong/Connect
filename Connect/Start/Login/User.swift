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
    let hastag1: String
    let hastag2: String
    let hastag3: String
    let hastag4: String
    let uid: String
}

extension User {
    static let sample: User = User(
        email: "", fullid: "", hastag1: "", hastag2: "", hastag3: "", hastag4: "", uid: "")
}

