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
        self.navigationController!.navigationBar.isHidden = false
        view.accessibilityIdentifier = "registerView"
        
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
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
                        self.performSegue(withIdentifier: "toLoginScreen", sender: self)
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
    
    @IBAction func onButtonClickCreateAccount(_ sender: UIButton) {
        handleRegister()
    }
    
    // hide keyboard, when touches outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

