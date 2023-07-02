//
//  LoginVC.swift
//  Chat-App
//
//  Created by ME-MAC on 7/1/23.
//

import UIKit
import ProgressHUD

class LoginVC: UIViewController, UITextFieldDelegate {
    
    //MARK: - IBOutlets
    //Labels
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwardLabel: UILabel!
    @IBOutlet weak var confirmPasswardLabel: UILabel!
    @IBOutlet weak var signUPLabel: UILabel!
    
    //TextFields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwardTextField: UITextField!
    @IBOutlet weak var confirmPasswrdTextField: UITextField!
    
    //Buttons
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var resendEmailButton: UIButton!
    
    //Views
    @IBOutlet weak var confirmPasswardLineView: UIView!
    
    //MARK: Vars
    
    var isLogin: Bool = true
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUIFor(login: isLogin)
        setupTextFieldsDelegates()
        setupBackgroundTap()
        loginButton.layer.cornerRadius = 10
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: isLogin ? "login" : "register") {
            //login or register
            print("have data for login/reg")
        } else {
            ProgressHUD.showFailed("All fields are required")
        }
    }
    
    @IBAction func forgotPasswardButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "passward") {
            //reset passward
            print("have data for forgot passward")
        } else {
            ProgressHUD.showFailed("Email is required")
        }
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "passward") {
            //resend verifacation email
            print("have data for resend email")
        } else {
            ProgressHUD.showFailed("Email is required")
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()

    }
    
    //MARK: - Setup
    
    private func setupTextFieldsDelegates() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwardTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmPasswrdTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        updatePlaceHolderLabels(textField: textField)
    }
    
    
    private func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTapped() {
        view.endEditing(true)
    }
    
    //MARK: - Animations
    
    private func updateUIFor(login: Bool) {
        signUPLabel.text = login ? "Don't have an account?" : "Have an account?"
        loginButton.setTitle(login ? "LOGIN" : "REGISTER", for: .normal)
        signUpButton.setTitle(login ? "Sign Up" : "Login" , for: .normal)
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.confirmPasswardLabel.isHidden = login
            self.confirmPasswrdTextField.isHidden = login
            self.confirmPasswardLineView.isHidden = login
            
        }
    }
    
    private func updatePlaceHolderLabels(textField: UITextField) {
        switch textField {
        case emailTextField:
            emailLabel.text = textField.hasText ? "Email" : ""
        case passwardTextField:
            passwardLabel.text = textField.hasText ? "Password" : ""
        default:
            confirmPasswardLabel.text = textField.hasText ? "Confirm Password" : ""

        }
    }
    
    //MARK: - Helpers
    
    private func isDataInputedFor(type : String) -> Bool {
        
        switch type {
        case "login":
            return emailTextField.text != "" && passwardTextField.text != ""
        case "register":
            return emailTextField.text != "" && passwardTextField.text != "" && confirmPasswrdTextField.text != ""
        default:
            return emailTextField.text != ""
        }
    }
}
