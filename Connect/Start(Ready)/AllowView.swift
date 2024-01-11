//
//  AllowView.swift
//  Linklife
//
//  Created by Daol on 1/8/24.
//

import SwiftUI

struct AllowView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isSigninViewActive = false

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 430, height: 932)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.02, green: 0.02, blue: 0.02), location: 0.00),
                            Gradient.Stop(color: .white, location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.19, y: 0.02),
                        endPoint: UnitPoint(x: 2.33, y: 2.9)
                    )
                )
            
            VStack {
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing:25) {
                        
                        Spacer()
                            .frame(width: 0)
                        
                        Image("backk")
                            .resizable()
                            .frame(width: 7, height: 13)
                        
                        Text("로그인")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                    }
                    .frame(width: UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : 375,
                           height: 20)
                }
                Spacer()
                
                VStack(spacing: 30) {
                    
                    VStack(spacing: 10) {
                        Image("wwhite")
                            .resizable()
                            .frame(width:65, height: 95)
                        Text("이용약관")
                            .font(.system(size: 60, weight: .black))
                            .foregroundColor(Color.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("1. 링크 라이프는 모든 사용자에게 쾌적한 환경을 제공하기 위해 노력합니다. 따라서 불쾌한 콘텐츠를 게시하거나 악의적인 행동을 하는 사용자는 서비스 이용이 제한되거나 계정이 정지될 수 있습니다.")
                            .foregroundColor(.white)
                        Text("2. 본 서비스를 이용함에 있어서 다른 사용자에세 불쾌감을 주거나, 피해를 주는 행동을 금지합니다. 이를 위반할 경우, 즉각적인 조치를 취하여 , 필요한 경우 법적인 절차를 밟을 수 있습니다.")
                            .foregroundColor(.white)
                        
                        Text("3. 본 서비스의 사용자는 서로를 존중하며, 불쾌한 콘텐츠를 게시하거나 악의적인 행동을 하지 않도록 약속해야 합니다. 이를 위반할 경우, 서비스 이용이 제한되거나 계정이 정지될 수 있습니다.")
                            .foregroundColor(.white)
                        
                    }
                    .frame(width:350,height: 280)
                    
                    NavigationLink(destination: SigninView().navigationBarBackButtonHidden(true), isActive: $isSigninViewActive) {
                        EmptyView()
                    }
                    
                    Button(action: {
                        isSigninViewActive = true
                    }) {
                        Text("동의하기")
                            .frame(width:200)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width == 430 ? 430 : UIScreen.main.bounds.width == 428 ? 428 : UIScreen.main.bounds.width == 414 ? 414 : UIScreen.main.bounds.width == 393 ? 393 : UIScreen.main.bounds.width == 390 ? 390 : UIScreen.main.bounds.width == 375 ? 375 : UIScreen.main.bounds.width == 320 ? 320 : 375,
                   height: UIScreen.main.bounds.height == 932 ? 750 : UIScreen.main.bounds.height == 926 ? 750 : UIScreen.main.bounds.height == 896 ? 630 : UIScreen.main.bounds.height == 852 ? 650 : UIScreen.main.bounds.height == 844 ? 644 : UIScreen.main.bounds.height == 812 ? 612 : UIScreen.main.bounds.height == 667 ? 300: UIScreen.main.bounds.height)
        }
        
    }
}

#Preview {
    AllowView()
}
