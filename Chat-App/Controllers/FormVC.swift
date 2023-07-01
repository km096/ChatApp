//
//  ViewController.swift
//  Chat-App
//
//  Created by ME-MAC on 6/29/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FormVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var formCollectionView: UICollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formCollectionView.delegate = self
        formCollectionView.dataSource = self
        
    }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "formCell", for: indexPath) as! SignFormCell
        
        if (indexPath.row == 0) {//Signin cell
            cell.userNameContainer.isHidden = true
            cell.actionBtn.setTitle("Login", for: .normal)
            cell.slideBtn.setTitle("Sign Up 👉", for: .normal)
            cell.slideBtn.addTarget(self, action: #selector(switchToSignIn), for: .touchUpInside)
            cell.actionBtn.addTarget(self, action: #selector(didPressLogin), for: .touchUpInside)
            
        } else if (indexPath.row == 1) {
            cell.userNameContainer.isHidden = false
            cell.actionBtn.setTitle("Sign Up", for: .normal)
            cell.slideBtn.setTitle("👈 Sign In", for: .normal)
            cell.slideBtn.addTarget(self, action: #selector(switchToSignUp), for: .touchUpInside)
            cell.actionBtn.addTarget(self, action: #selector(didPressSignUp), for: .touchUpInside)
        }
            return cell
    }
    
    @objc func didPressLogin(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.formCollectionView.cellForItem(at: indexPath) as! SignFormCell
        guard let email = cell.emailAddressTxt.text,
              let password = cell.passwordTxt.text else {
            return
        }
        
        if email.isEmpty || password.isEmpty {
            self.displayError(errorMsg: "Please fill empty fields")
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                guard let strongSelf = self else {
                    return
                }
                
                if error == nil {
                    strongSelf.dismiss(animated: true)
                } else {
                    strongSelf.displayError(errorMsg: error!.localizedDescription)
                }
            }
        }
    }
    
    @objc func didPressSignUp(_ sender: UIButton) {
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = self.formCollectionView.cellForItem(at: indexPath) as! SignFormCell
        guard let username = cell.userNameTxt.text, !username.isEmpty,
              let email = cell.emailAddressTxt.text, !email.isEmpty,
              let password = cell.passwordTxt.text, !password.isEmpty else {
            return
        }
        
        if isValidEmail(email) || password.count < 6 {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
                guard let strongSelf = self else {
                    return
                }
                
                if error == nil {
                                        
                    guard let userId = user?.user.uid,
                          let userName = cell.userNameTxt.text else {
                        return
                    }
                                        
                    var databaseRef: DatabaseReference!
                    databaseRef = Database.database().reference()
                    
                    let user = databaseRef.child("users").child(userId)
                    let data : [String: Any] = ["username": userName, "email": email]
                    user.setValue(data)
                    
                    strongSelf.dismiss(animated: true)
                } else {
                    strongSelf.displayError(errorMsg: "\(error?.localizedDescription)")
                }
            }
        } else {
            self.displayError(errorMsg: "Please enter valid email or password")
        }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Regular expression pattern for validating email
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    @objc func switchToSignIn(_ sender: UIButton) {
        let indexPath = IndexPath(row: 1, section: 0)
        self.formCollectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    
    @objc func switchToSignUp(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        self.formCollectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    
    func displayError(errorMsg: String) {
        let alert  = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    
}

