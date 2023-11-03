//
//  UserDataModel.swift
//  Connect
//
//  Created by Daol on 2023/09/08.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserDataModel: ObservableObject {
    @Published var user: DBUser?
    @Published var users = [DBUser]() // Array to store all users
    @Published var currentUser: DBUser?
    
    public var uid: String {
          Auth.auth().currentUser?.uid ?? ""
      }

    init() {}
    func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid, !uid.isEmpty else {
               print("Error: No current user")
               return
           }
        
        let db = Firestore.firestore()

        db.collection("users").document(uid).getDocument { document, error in
            
            if let error = error {
                print("Error fetching user: \(error)")
                return
            }
            
            if let document = document, document.exists {
                do {
                    self.user = try document.data(as: DBUser.self)
                } catch let error as NSError {
                    print("Error decoding user: \(error)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    func fetchUsers() {
        guard let uid = Auth.auth().currentUser?.uid, !uid.isEmpty else {
                print("Error: No current user")
                return
            }
        
        let db = Firestore.firestore()

        db.collection("users").getDocuments { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else if querySnapshot!.documents.isEmpty{
                   print("No documents found")
               }else{
                   for document in querySnapshot!.documents{
                       do{
                           if let user = try? document.data(as: DBUser.self){
                               if !self.users.contains(where: { $0.uid == user.uid }) {
                                   self.users.append(user)
                               }
                           }
                       }
                   }
               }
           }
       }
    
    func addFriend(_ currentUserId : String , _ friendUserId : String, completion: @escaping (Result<Void, Error>) -> Void ) {
       let db = Firestore.firestore()

       db.collection("users").document(currentUserId).updateData([
           "friends": FieldValue.arrayUnion([friendUserId])
       ]) { error in
           if let error = error {
               completion(.failure(error))
           } else {
               completion(.success(()))
           }
       }

       db.collection("users").document(friendUserId).updateData([
           "friends": FieldValue.arrayUnion([currentUserId])
       ]) { error in
           if let error = error {
               completion(.failure(error))
           } else {
               completion(.success(()))
           }
       }
    }
    
    func fetchfriendUser() {
        let db = Firestore.firestore()

        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Error fetching user: \(error)")
                return
            }

            if let document = document, document.exists {
                do {
                    self.user = try document.data(as: DBUser.self)
                } catch let error as NSError {
                    print("Error decoding user: \(error)")
                }
            } else {
                print("Document does not exist or is nil")
                self.user = nil
            }
        }
    }
    
    func getCurrentUser(uid: String) {
        let db = Firestore.firestore()

        guard !uid.isEmpty else {
            print("Error: No current user")
            return
        }
        
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Error fetching user: \(error)")
                return
            }

            if let document = document, document.exists {
                do {
                    self.currentUser = try document.data(as: DBUser.self)
                } catch let error as NSError {
                    print("Error decoding user: \(error)")
                }
            } else {
                print("Document does not exist or is nil")
                self.currentUser = nil
            }
        }
    }

}
