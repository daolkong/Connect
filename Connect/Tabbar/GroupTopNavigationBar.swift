//
//  GroupTopNavigationBar.swift
//  MomentsShare
//
//  Created by Daol on 2023/09/01.
//

import SwiftUI

struct GroupTopNavigationBar: View {
    @State var TextLogo: String
    @State var AlarmItem: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(TextLogo)
                .resizable()
                .frame(width: 7, height: 13)
            
            Text(AlarmItem)
                .font(.system(size: 23, weight:.semibold))
    
            Spacer()
            
            Text("친구")
                .font(.system(size: 15, weight:.heavy))
                .foregroundColor(Color(red: 0.78, green: 0.77, blue: 0.77))
            
            Text("그룹")
                .font(.system(size: 15, weight:.heavy))
                .foregroundColor(Color(red: 0.32, green: 0.53, blue: 0.84))
         
        }
        .padding()
    }
}

struct GroupTopNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        GroupTopNavigationBar(TextLogo: "back1", AlarmItem: "Moment Save")
    }
}
