//
//  RegisterViewController.swift
//  schwablication
//
//  Created by bi on 29.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import Foundation
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "registerView"
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    
    /// Performing a sign up to the firebase authentication system.
    /// Checking if the input is wrong and popping an alert if so
    /// otherwise creating the user and navigating to login view.
    func handleRegister(){
        guard let email = emailTextField.text else { return }
        guard let pass = passwordTextField.text else { return }

        let alertController = Alert()
        if(!email.isEmpty && !pass.isEmpty){
            Auth.auth().createUser(withEmail: email, password: pass) { user, error in
                if error == nil && user != nil {
                    print("User created")
                    let alertController = UIAlertController(title: "Success", message: "User created", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion:nil)
                } else {
                    print("Error creating user")
                    alertController.showBasic(title: "Error creating account", message: error!.localizedDescription , vc: self)
                }
            }
        } else {
            alertController.showBasic(title: "Incomplete Form", message: "E-Mail and password field are required." , vc: self)
        }
    }
    
    /// Button event handler for "Create Account". Firing the sign up function.
    @IBAction func onButtonClickCreateAccount(_ sender: UIButton) {
        handleRegister()
    }
    
    // hide keyboard, when touches outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

