//
//  User.swift
//  Chat-App
//
//  Created by ME-MAC on 7/2/23.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable, Equatable {
    
    var id = ""
    var username: String?
    var email: String?
    var pushId = ""
    var avatarLink = ""
    var status: String?
    
    init(id: String = "", username: String? = nil, email: String? = nil, pushId: String = "", avatarLink: String = "", status: String? = nil) {
        self.id = id
        self.username = username
        self.email = email
        self.pushId = pushId
        self.avatarLink = avatarLink
        self.status = status
    }
    
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            
            //check if there is loged in user in user defaults
            //take saved data in user defaults and decode it to a USER object
            //kCURRENTUSER is a key in constants file
            if let dictionary = UserDefaults.standard.data(forKey: kCURRENTUSER) {
                
                let decoder = JSONDecoder()
                
                do {
                    let userObject = try decoder.decode(User.self, from: dictionary)
                    return userObject
                } catch {
                    print("Error decoding user from user defaults : \(error.localizedDescription)")
                }
            }
        }
        
        return nil
    }
    
    static func == (lfh: User, rhs: User) -> Bool {
        lfh.id == rhs.id
    }
}

//Save the new user in user defaults
//In order to save anything to user dafaults we have to encode it to a simple value(string, int, ...)
func saveUserLocally(_ user: User) {
    
    let encoder = JSONEncoder()
    
    do {
        let data = try encoder.encode(user)
        UserDefaults.standard.set(data, forKey: kCURRENTUSER)
    } catch {
        print("Error saving user data locally: \(error.localizedDescription)")
    }
    
}
