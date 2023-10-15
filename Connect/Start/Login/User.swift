//
//  User.swift
//  Connect
//
//  Created by Daol on 2023/09/02.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    let email: String
    let userId: String   
    let hastags: String
    let uid: String
    var profileImageURL: String?  // Add this line.
    var uploadedImagesURLs: [String]? // Add this line.
    var friends: [String]
    
    var id: String { uid }

}

extension User {
    static let sample: User = User(
        email: "", userId: "", hastags: "", uid: "", friends: [])
}


