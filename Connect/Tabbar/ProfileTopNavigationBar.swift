//
//  ProfileTopNavigationBar.swift
//  MomentsShare
//
//  Created by Daol on 2023/09/01.
//

import SwiftUI

struct ProfileTopNavigationBar: View {
    @State var imageLogo: String
    @State var TextLogo: String
    @State var AlarmItem: String

    var body: some View {
        HStack(spacing: 115) {
            Image(TextLogo)
                .resizable()
                .frame(width: 7, height: 13)
            
            Text(AlarmItem)
                .font(.system(size: 23))
                .fontWeight(.semibold)
    
            Image(imageLogo)
                .resizable()
                .frame(width: 15.5, height: 15.5)
        }
    }
}

struct ProfileTopNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTopNavigationBar(imageLogo: "Search2", TextLogo: "back1", AlarmItem: "Profile")
    }
}
