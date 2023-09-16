//
//  ConnectApp.swift
//  Connect
//
//  Created by Daol on 2023/09/02.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct ConnectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var userDataModel = UserDataModel()
    @StateObject var notificationViewModel = NotificationViewModel() // NotificationViewModel 인스턴스 생성

    
    var body: some Scene {
        WindowGroup {
            FirstStartView()
                .environmentObject(authViewModel)
                .environmentObject(userDataModel)
                .environmentObject(notificationViewModel) // NotificationViewModel 인스턴스 제공

        }
        
    }
}
