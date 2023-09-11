//
//  fgfgd.swift
//  Connect
//
//  Created by Daol on 2023/09/04.
//

import SwiftUI

struct fgfgd: View {
    @State private var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            Text("Home")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
                .background(
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 303, height: 65)
                        .background(.white)
                        .cornerRadius(40)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
                )
            
            Text("Settings")
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(1)
        }
    }
}




struct fgfgd_Previews: PreviewProvider {
    static var previews: some View {
        fgfgd()
    }
}
