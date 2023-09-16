//
//  ContentView.swift
//  Connect
//
//  Created by Daol on 2023/09/02.
//

import SwiftUI

struct MainView: View {
    @State var selectedTab = ""
    @State var TabSelection = 1
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TabView (selection: $TabSelection) {
                    HomeView(imageUrl:"")
                        .tag(1)

                    Time_sellectView()
                        .tag(2)

                    MyprofileView()
                        .tag(3)
                    
                        
                    }
                }
//                CustomTabBar(TabSelection: $TabSelection, selectedTab: $selectedTab)
            }
            
        }
    }


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
