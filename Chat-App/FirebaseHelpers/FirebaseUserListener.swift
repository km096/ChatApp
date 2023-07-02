//
//  FirebaseUserListener.swift
//  Chat-App
//
//  Created by ME-MAC on 7/2/23.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
 
class FirebaseUserListener {
    
    static let shared = FirebaseUserListener()
    
    private init() {}
    
    //MARK: - Login
    
    //MARK: - Register
    
    //NOTE: the registeration or anything related to firebase is happening on a background thread so we need a way to be informed once the task on the background thread is completed so the completion is going to inform us when the task is finished
    func registerUserWith(email: String, passward: String, completion: @escaping (_ error: Error?) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: passward) { authResult, error in
            
            completion(error)
            
            if error == nil {
                
                //Send verfication email
                authResult!.user.sendEmailVerification(completion: { error in
                    print("Auth email sent with error: \(error?.localizedDescription)")
                })
            }
            
            //Create user and save it
            if authResult?.user != nil {
                let user = User(id: authResult!.user.uid, username: email, email: email, pushId: "", avatarLink: "", status: "Hey ther I'm using ChatApp")
            }
        }
    }
}
