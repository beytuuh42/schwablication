//
//  LoginViewController.swift
//  schwablication
//
//  Created by bi on 29.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import Foundation
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var onBottonClickRegister: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func handleLogin(){
        guard let email = emailTextField.text else { return }
        guard let pass = passwordTextField.text else { return }

        let alertController = Alert()
        if(!email.isEmpty && !pass.isEmpty){
            Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                if error == nil && user != nil {
                    let alertController = UIAlertController(title: "Success", message: "Successfully logged in!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        self.performSegue(withIdentifier: "toHomeScreen", sender: self)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion:nil)
                } else {
                    print("Error login")
                    alertController.showBasic(title: "Error login", message: error!.localizedDescription , vc: self)
                }
            }
        } else {
            alertController.showBasic(title: "Incomplete Form", message: "E-Mail and password field are required." , vc: self)
        }
    }
    
    @IBAction func onButtonClickLogin(_ sender: Any) {
        handleLogin()
    }
}
