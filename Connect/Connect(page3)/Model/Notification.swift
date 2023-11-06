//
//  Notification.swift
//  Connect
//
//  Created by Daol on 9/25/23.
//

import Foundation

extension Array where Element == Notification {
    func removingDuplicates() -> [Element] {
        var addedDict = [String: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0.fromUserId) == nil
        }
    }
}

struct Notification: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let fromUserId: String
    let toUserId: String
    var fromUserProfileImageUrl: String?
    var latestPostImageUrl: String?
    var time: Date?  // Add this line

    enum CodingKeys: String, CodingKey {
        case id
        case fromUserId = "from"
        case toUserId = "to"
        case fromUserProfileImageUrl = "fromUserProfileImageUrl"
        case latestPostImageUrl = "latestPostImageUrl"
        case time  // Add this line
    }

    init(id: String,
          fromUserId: String,
          toUserId: String,
          fromUserProfileImageUrl: String?,
          latestPostImageUrl: String?,
          time: Date?) {  // Add this line

        self.id = id
        self.fromUserId = fromUserId
        self.toUserId = toUserId
        self.fromUserProfileImageUrl = fromUserProfileImageUrl
        self.latestPostImageUrl = latestPostImageUrl
        self.time = time  // Add this line
    }
    
    static func == (lhs: Notification, rhs: Notification) -> Bool {
        return lhs.fromUserId == rhs.fromUserId
    }
}
