//
//  DBUser.swift
//  Connect
//
//  Created by Daol on 2023/09/02.
//

import Foundation

struct DBUser: Codable, Identifiable, Hashable {
    let email: String
    let userId: String   
    let hastags: String
    let uid: String
    var profileImageURL: String?  // Add this line.
    var uploadedImagesURLs: [String]? // Add this line.
    var friends: [String]
    
    var id: String { uid }        
}

extension DBUser {
    static let sample: DBUser = DBUser(
        email: "", userId: "", hastags: "", uid: "", friends: [])
}
