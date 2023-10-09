//
//  Notification.swift
//  Connect
//
//  Created by Daol on 9/25/23.
//

import Foundation

struct Notification: Identifiable {
    let id: String
    let fromUserId: String
    let fromUserName: String
    var fromUserProfileImageUrl: String? // Make this an optional string
    
    init(id: String,
         fromUserId: String,
         fromUserName: String,
         fromUserProfileImageUrl:String? = nil) { // And here as well
        self.id = id
        self.fromUserId = fromUserId
        self.fromUserName = fromUserName
        self.fromUserProfileImageUrl =  fromUserProfileImageUrl
    }
}

