//
//  ContentView.swift
//  Connect
//
//  Created by Daol on 2023/09/12.
//

import SwiftUI

struct ContentView: View {
    
    @State var isDarkModeOn = false
    
    var body: some View {
        NavigationView {
           
                VStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(hex: 0xF2F1F6))
                            .frame(width: 1000,height: 1000)
                        VStack {
                            Text ("설정")
                                .font(.system(size: 42))
                                .bold()
                            
                                .padding(.trailing,282)
                            ZStack {
                                Rectangle()
                                    .frame(width: 361,height: 49)
                                    .cornerRadius(12)
                                    .foregroundColor(Color(hex: 0xE4E3E9))
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 25))
                                        .foregroundColor(Color(hex: 0x828188))
                                    
                                    Text("검색")
                                        .font(.system(size: 23))
                                        .foregroundColor(Color(hex: 0x8D8C93))
                                }
                                .padding(.trailing,254)
                            }
                            NavigationLink(destination: app_1()) {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 361,height: 96)
                                        .cornerRadius(12)
                                        .foregroundColor(.white)
                                    HStack(spacing: 20) {
                                        Image("em")
                                            .resizable()
                                            .frame(width: 75,height: 75)
                                            .cornerRadius(70)
                                        VStack(spacing: 6) {
                                            Text("유민서")
                                                .font(.system(size: 24))
                                                .padding(.trailing,170)
                                            Text("Apple ID, iCloud+, 미디어 및 구입")
                                                .font(.system(size: 15))
                                                .padding(.trailing,20)
                                        }
                                    }
                                }
                                .foregroundColor(.black)
                            }
                            
                            
                            ZStack {
                                Rectangle()
                                    .frame(width: 361,height: 270)
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                                VStack {
                                    
                                    HStack(spacing: 10) {
                                        ZStack {
                                            Rectangle()
                                                .frame(width:30,height: 30)
                                                .cornerRadius(4)
                                                .foregroundColor(Color(hex: 0xED9B37))
                                            Image(systemName: "airplane")
                                                .foregroundColor(.white)
                                        }
                                        
                                        Text("에어플레인 모드")
                                        
                                        HStack {
                                            Toggle("다크모드", isOn: $isDarkModeOn)
                                                .tint(Color(red: 0.52, green: 0.69, blue: 0.94))
                                                .font(.system(size: 18))
                                        }
                                    }
                                    .padding(.trailing,165)
                                    
                                    Rectangle()
                                        .frame(width: 361,height: 1)
                                        .foregroundColor(Color.gray)
                                    
                                    NavigationLink(destination: app_wifi()) {
                                        HStack {
                                            ZStack {
                                                Rectangle()
                                                    .frame(width:30,height: 30)
                                                    .cornerRadius(4)
                                                    .foregroundColor(Color(hex: 0x3577F8))
                                                
                                                Image(systemName: "wifi")
                                                    .foregroundColor(.white)
                                            }
                                            Text("Wi-Fi")
                                                .font(.system(size: 20))
                                                .padding(.trailing,147)
                                            
                                            Text("gschool >")
                                                .font(.system(size: 18))
                                                .foregroundColor(Color(hex: 0x89898B))
                                        }
                                        .foregroundColor(.black)
                                    }
                                    Rectangle()
                                        .frame(width: 361,height: 1)
                                        .foregroundColor(Color.gray)
                                    
                                    NavigationLink(destination: app_Bluetooth()) {
                                        HStack {
                                            ZStack {
                                                Rectangle()
                                                    .frame(width:30,height: 30)
                                                    .cornerRadius(4)
                                                    .foregroundColor(Color(hex: 0x3577F8))
                                                Image(systemName: "wifi")
                                                    .foregroundColor(.white)
                                            }
                                            Text("Bluetooth")
                                                .font(.system(size: 20))
                                                .padding(.trailing,155)
                                            
                                            Text("켬 >")
                                                .font(.system(size: 18))
                                                .foregroundColor(Color(hex: 0x89898B))
                                        }
                                        .foregroundColor(.black)
                                    }
                                    Rectangle()
                                        .frame(width: 361,height: 1)
                                        .foregroundColor(Color.gray)
                                    
                                    NavigationLink(destination: app_4()) {
                                        HStack {
                                            ZStack {
                                                Rectangle()
                                                    .frame(width:30,height: 30)
                                                    .cornerRadius(4)
                                                    .foregroundColor(Color(hex: 0x66C367))
                                                Image(systemName: "wifi")
                                                    .foregroundColor(.white)
                                            }
                                            Text("셀룰러")
                                                .font(.system(size: 20))
                                                .padding(.trailing,209)
                                            Text(">")
                                                .font(.system(size: 18))
                                                .foregroundColor(Color(hex: 0x89898B))
                                        }
                                        .foregroundColor(.black)
                                    }
                                    Rectangle()
                                        .frame(width: 361,height: 1)
                                        .foregroundColor(Color.gray)
                                    
                                    
                                    NavigationLink(destination: app_5()) {
                                        HStack {
                                            ZStack {
                                                Rectangle()
                                                    .frame(width:30,height: 30)
                                                    .cornerRadius(4)
                                                    .foregroundColor(Color(hex: 0x66C367))
                                                Image(systemName: "wifi")
                                                    .foregroundColor(.white)
                                            }
                                            Text("개인용 핫스팟")
                                                .font(.system(size: 20))
                                                .padding(.trailing,133)
                                            
                                            Text("끔 >")
                                                .font(.system(size: 18))
                                                .foregroundColor(Color(hex: 0x89898B))
                                        }
                                        .foregroundColor(.black)
                                    }
                                    
                                }
                                
                            }
                            .padding()
                            
                            .padding(.top,30)
                        }
                        
                        
                        
                    }
                }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
