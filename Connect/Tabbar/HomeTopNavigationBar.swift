//
//  TopNavigationBar.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/30.
//

import SwiftUI

struct HomeTopNavigationBar: View {


    
    var body: some View {
            HStack(spacing: 98) {
                Image("align-left")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text("Connect")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
        
                Image("users")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
    }
}

struct HomeTopNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeTopNavigationBar()
    }
}
