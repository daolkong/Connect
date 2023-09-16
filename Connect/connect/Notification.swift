//
//  Notification.swift
//  Connect
//
//  Created by Daol on 9/25/23.
//

import SwiftUI

struct Notification: Identifiable {
    let id: String
    let fromUserId: String
    let fromUserName: String
    
    
    init(id: String, fromUserId: String, fromUserName: String) {
        self.id = id
        self.fromUserId = fromUserId
        self.fromUserName = fromUserName
    }
}


