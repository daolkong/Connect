//
//  ProfileTopNavigationBar.swift
//  MomentsShare
//
//  Created by Daol on 2023/09/01.
//

import SwiftUI

struct ProfileTopNavigationBar: View {
    @State var TextLogo: String


    var body: some View {
        HStack(spacing: 11) {
            Image(TextLogo)
                .resizable()
                .frame(width: 10, height: 16)
    
          Spacer()
        }
        .padding()
        .padding(.leading,6)

    }
}

struct ProfileTopNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTopNavigationBar(TextLogo: "back1")
    }
}
