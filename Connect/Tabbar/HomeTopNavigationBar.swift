//
//  TopNavigationBar.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/30.
//

import SwiftUI

struct HomeTopNavigationBar: View {
    @State var imageLogo: String
    @State var TextLogo: String
    @State var AlarmItem: String

    
    var body: some View {
            HStack(spacing: 98) {
                Image(TextLogo)
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text(AlarmItem)
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
        
                Image(imageLogo)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
    }
}

struct HomeTopNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeTopNavigationBar(imageLogo: "users", TextLogo: "align-left", AlarmItem: "Connect")
    }
}
