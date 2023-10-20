//
//  ConnectModel.swift
//  Connect
//
//  Created by Daol on 10/18/23.
//

import Foundation

struct ConnectModel: Codable {
    var selectedTab1: Int
    var selectedTab2: Int
    var selectedTab3: Int
    var selectedTab4: Int
    
    var postA1ID: String?
    var postB1ID: String?
    
    var postA2ID: String?
    var postB2ID: String?

    var postA3ID: String?
    var postB3ID: String?

    var postA4ID: String?
    var postB4ID: String?
}

