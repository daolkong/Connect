//
//  AlarmTopNavigationBar.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/31.
//

import SwiftUI

struct AlarmTopNavigationBar: View {
    @State var TextLogo: String
    @State var AlarmItem: String
    
    var body: some View {
        HStack(spacing: 25) {
            Image(TextLogo)
                .resizable()
                .frame(width: 7, height: 13)
            
            Text(AlarmItem)
                .font(.system(size: 23))
                .fontWeight(.semibold)
            
           
        }
        .padding(.trailing,180)

    }
}

struct AlarmTopNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        AlarmTopNavigationBar(TextLogo: "back1", AlarmItem: "Nontifications")
    }
}
