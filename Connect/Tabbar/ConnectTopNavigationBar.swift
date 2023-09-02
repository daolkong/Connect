//
//  ConnectTopNavigationBar.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/31.
//

import SwiftUI

struct ConnectTopNavigationBar: View {
    @State var imageLogo: String
    @State var TextLogo: String
    @State var AlarmItem: String
    
    
    var body: some View {
        
        HStack(spacing: 58) {
            Image(TextLogo)
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(AlarmItem)
                .font(.system(size: 25))
                .fontWeight(.semibold)
            
            Image(imageLogo)
                .resizable()
                .frame(width: 18, height: 20)
        }
    }
}

struct ConnectTopNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ConnectTopNavigationBar(imageLogo: "alarm", TextLogo: "align-left", AlarmItem: "Connect Gallery")
    }
}
