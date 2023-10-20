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
    let toUserId: String  // Add this line
    var fromUserProfileImageUrl: String?
    var latestPostImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fromUserId = "from"
        case toUserId = "to"
        case fromUserProfileImageUrl = "fromUserProfileImageUrl"
        case latestPostImageUrl = "latestPostImageUrl"
    }

   init(id: String,
         fromUserId: String,
         toUserId:String,
         fromUserProfileImageUrl:String?,
         latestPostImageUrl:String?) {

       self.id = id
       self.fromUserId = fromUserId
       self.toUserId = toUserId
       self.fromUserProfileImageUrl = fromUserProfileImageUrl
       self.latestPostImageUrl = latestPostImageUrl
   }
    
    static func == (lhs: Notification, rhs: Notification) -> Bool {
         return lhs.fromUserId == rhs.fromUserId
     }
}
