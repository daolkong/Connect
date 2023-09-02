//
//  ConnectAllowView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI

struct ConnectAllowView: View {
    @State private var isButtonPressed = false
    @State private var isButtonPressed1 = false
    @State private var isButtonPressed2 = false
    @State private var isButtonPressed3 = false


    var body: some View {
        VStack(spacing: 20) {
            AlarmTopNavigationBar(TextLogo: "back1", AlarmItem: "Nontifications")
            
            
            // Connect 버튼
            ZStack {
                Rectangle()
                    .foregroundColor(Color(red: 0.52, green: 0.69, blue: 0.94))
                    .frame(width: 86, height: 34)
                    .cornerRadius(30)
                
                Text("Connect")
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
            }
            .padding(.trailing,280)
            
            ScrollView {
                // 알림창 1
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            Text("susun_hit 님이 회원님과의 일상을 connect 하고 싶어 합니다. ")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        Button(action: {
                                 self.isButtonPressed.toggle()
                             }) {
                                 ZStack {
                                     Rectangle()
                                         .foregroundColor(Color(red: 0.79, green: 0.78, blue: 0.78))
                                         .frame(width: 47, height: 45)
                                         .cornerRadius(6)

                                     if isButtonPressed {
                                         Image("check3")
                                             .resizable()
                                             .frame(width: 29, height: 29)
                                     } else {
                                         Image("whitechain")
                                             .resizable()
                                             .frame(width: 29, height: 29)
                                     }
                                 }
                             }
                        
                        
                    }
                    .padding(.trailing,20)
                    
                    
                    
                }
                // 알림창 2
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            Text("susun_hit 님이 회원님과의 일상을 connect 하고 싶어 합니다. ")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        Button(action: {
                                 self.isButtonPressed1.toggle()
                             }) {
                                 ZStack {
                                     Rectangle()
                                         .foregroundColor(Color(red: 0.79, green: 0.78, blue: 0.78))
                                         .frame(width: 47, height: 45)
                                         .cornerRadius(6)

                                     if isButtonPressed1 {
                                         Image("check3")
                                             .resizable()
                                             .frame(width: 29, height: 29)
                                     } else {
                                         Image("whitechain")
                                             .resizable()
                                             .frame(width: 29, height: 29)
                                     }
                                 }
                             }
                    }
                    .padding(.trailing,20)
                    
                    
                    
                }
                // 알림창 3
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            Text("susun_hit 님이 회원님과의 일상을 connect 하고 싶어 합니다. ")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        Button(action: {
                                 self.isButtonPressed2.toggle()
                             }) {
                                 ZStack {
                                     Rectangle()
                                         .foregroundColor(Color(red: 0.79, green: 0.78, blue: 0.78))
                                         .frame(width: 47, height: 45)
                                         .cornerRadius(6)

                                     if isButtonPressed2 {
                                         Image("check3")
                                             .resizable()
                                             .frame(width: 29, height: 29)
                                     } else {
                                         Image("whitechain")
                                             .resizable()
                                             .frame(width: 29, height: 29)
                                     }
                                 }
                             }
                    }
                    .padding(.trailing,20)
                    
                    
                    
                }
                // 알림창 4
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            Text("susun_hit 님이 회원님과의 일상을 connect 하고 싶어 합니다. ")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        Button(action: {
                                 self.isButtonPressed3.toggle()
                             }) {
                                 ZStack {
                                     Rectangle()
                                         .foregroundColor(Color(red: 0.79, green: 0.78, blue: 0.78))
                                         .frame(width: 47, height: 45)
                                         .cornerRadius(6)

                                     if isButtonPressed3 {
                                         Image("check3")
                                             .resizable()
                                             .frame(width: 29, height: 29)
                                     } else {
                                         Image("whitechain")
                                             .resizable()
                                             .frame(width: 29, height: 29)
                                     }
                                 }
                             }
                    }
                    .padding(.trailing,20)
                    
                    
                    
                }
            }
            .frame(height: 160)
            
// ----------------------------------------------------------------------
            
            // Like 버튼
            ZStack {
                Rectangle()
                    .foregroundColor(Color(red: 0.12, green: 0.14, blue: 0.14))
                    .frame(width: 64, height: 34)
                    .cornerRadius(30)
                
                Text("Like")
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
            }
            .padding(.trailing,300)
            
            ScrollView {
                // 알림창 1
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            Text("susun_hit 님이 회원님의 게시물을 좋아합니다. ")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        
                        Image("heart button")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .padding(.leading,30)
                        
                    }
                    .padding(.trailing,50)
                    
                    
                    
                }
                // 알림창 2
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            Text("susun_hit 님이 회원님의 게시물을 좋아합니다. ")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        
                        Image("heart button")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .padding(.leading,30)
                        
                    }
                    .padding(.trailing,50)
                    
                    
                    
                }
                // 알림창 3
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            Text("susun_hit 님이 회원님의 게시물을 좋아합니다. ")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        
                        Image("heart button")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .padding(.leading,30)
                        
                    }
                    .padding(.trailing,50)
                    
                    
                    
                }
                // 알림창 4
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            Text("susun_hit 님이 회원님의 게시물을 좋아합니다. ")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        
                        Image("heart button")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .padding(.leading,30)
                        
                    }
                    .padding(.trailing,50)
                    
                    
                    
                }
                // 알림창 5
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            Text("susun_hit 님이 회원님의 게시물을 좋아합니다. ")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        
                        Image("heart button")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .padding(.leading,30)
                        
                    }
                    .padding(.trailing,50)
                    
                    
                    
                }
                // 알림창 6
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            Text("susun_hit 님이 회원님의 게시물을 좋아합니다. ")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        
                        Image("heart button")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .padding(.leading,30)
                        
                    }
                    .padding(.trailing,50)
                    
                    
                    
                }
                // 알림창 7
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            Text("susun_hit 님이 회원님의 게시물을 좋아합니다. ")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        
                        Image("heart button")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .padding(.leading,30)
                        
                    }
                    .padding(.trailing,50)
                    
                    
                    
                }
                // 알림창 8
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 369, height: 73)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269447327, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)), Color(#colorLiteral(red: 0.5176470875740051, green: 0.686274528503418, blue: 0.9372549057006836, alpha: 1))]), startPoint: .leading, endPoint : .trailing),
                                    lineWidth : 2 // Specify your desired line width here
                                ))
                    
                    HStack {
                        HStack {
                            Image("profile")
                                .resizable()
                                .frame(width: 44, height: 44)
                            Text("susun_hit 님이 회원님의 게시물을 좋아합니다. ")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .frame(width: 300)
                        
                        .padding(.trailing,5)
                        
                        
                        Image("heart button")
                            .resizable()
                            .frame(width: 38, height: 38)
                            .padding(.leading,30)
                        
                    }
                    .padding(.trailing,50)
                    
                    
                    
                }
            }
            
            
        }
    }
}

struct ConnectAllowView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectAllowView()
    }
}
