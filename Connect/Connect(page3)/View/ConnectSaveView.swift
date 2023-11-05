//
//  ConnectSaveView.swift
//  MomentsShare
//
//  Created by Daol on 2023/08/29.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct ConnectSaveView: View {
    @EnvironmentObject var sharedViewModel : SharedViewModel
    @State private var connectNumerData: [String: Int] = [:]
    @State private var maxConnectNumer: (key: String, value: Int)? = nil
    
    var body: some View {
        VStack(spacing:10) {
            // 1위
            VStack(spacing: -23) {
                ZStack {
                    ZStack {
                        Rectangle()
                            .frame(width: 340, height: 80)
                            .foregroundColor(.clear)
                            .background(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.97, green: 0.76, blue: 0.76).opacity(0.3), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.52, green: 0.69, blue: 0.94).opacity(0.3), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.58, y: 0),
                                    endPoint: UnitPoint(x: 0.64, y: 1)
                                )
                            )
                            .cornerRadius(12)
                        
                        HStack {
                            Spacer()
                                .frame(maxWidth: 20)
                            
                            Image("image 2")
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                            
                            
                            Spacer()
                                .frame(maxWidth: 20)
                            
                            Text(maxConnectNumer.map { "\($0.key)님과 \($0.value)번 커넥트 하셨습니다." } ?? "")
                                .font(.system(size: 17, weight: .medium))
                                .frame(width: 150,alignment: .leading)
                            
                            Spacer()
                                .frame(maxWidth: 40)
                            
                            Text(maxConnectNumer.map { "\($0.value)" } ?? "")
                                .foregroundColor(Color(red: 0.19, green: 0.2, blue: 0.23))
                                .font(Font.system(size: 40, weight: .black))
                                .frame(width: 43,alignment: .leading)

                            
                            Spacer()
                                .frame(width: 20)
                        }
                    }
                    
                    Image("Winn")
                        .resizable()
                        .frame(width: 44, height: 41)
                        .padding(.bottom,110)
                        .padding(.trailing,254)
                }
                
                Path { path in
                    path.move(to: CGPoint(x: 45, y: 20))
                    path.addLine(to: CGPoint(x: UIScreen.main.bounds.width - 20, y: 20))
                }
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                .frame(width: 410,height: 40)
                
            }
            
            //-----------------------------------------------------------------------------------------------------------------------------------------
            ScrollView {
                ForEach(connectNumerData.sorted(by: >), id: \.key) { key, value in
                    ZStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.97, green: 0.76, blue: 0.76).opacity(0.3), location: 0),
                                        Gradient.Stop(color: Color(red: 0.52, green: 0.69, blue: 0.94).opacity(0.3), location: 1)
                                    ],
                                    startPoint: UnitPoint(x: 0.58, y: 0),
                                    endPoint: UnitPoint(x: 0.64, y: 1)
                                ), lineWidth: 3)
                                .frame(width: 327, height: 67)
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.clear, lineWidth: 2)
                                .frame(width: 329, height: 69)
                        }
                        
                        HStack{
                            Spacer()
                                .frame(maxWidth: 13)
                            
                            Circle()
                                .frame(width: 40, height: 40)
                            
                            Spacer()
                                .frame(maxWidth: 20)
                            
                            Text("\(key)님과 \(value)번 커넥트 하셨습니다.")
                                .font(.system(size: 14, weight: .medium))
                                .frame(width: 140,alignment: .leading)
                            
                            Spacer()
                                .frame(maxWidth: 70)
                            
                            Text("\(value)")
                                .font(.system(size: 25, weight: .bold))
                                .frame(width: 46, alignment: .leading)
                            
                            Spacer()
                                .frame(width: 2)
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        guard let uid = Auth.auth().currentUser?.uid else {
                            print("No current user logged in.")
                            return
                        }
                        guard let document = try? await Firestore.firestore().collection("users").document(uid).getDocument(),
                              let dbUser = try? document.data(as: DBUser.self) else {
                            print("Error getting userId for the current user")
                            return
                        }
                        let userId = dbUser.userId
                        connectNumerData = try await sharedViewModel.getConnectNumer(userId: userId)
                        connectNumerData = try await sharedViewModel.getConnectNumer(userId: userId)
                        maxConnectNumer = connectNumerData.max { a, b in a.value < b.value }
                    } catch {
                        print("Error getting connect numer data:", error)
                    }
                }
            }
        }
    }
}

struct ConnectSaveView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectSaveView()
    }
}
