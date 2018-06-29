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
    @IBOutlet weak var txtField_pass: UITextField!
    @IBOutlet weak var txtField_email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func handleLogin(){
        guard let email = txtField_email.text else { return }
        guard let pass = txtField_pass.text else { return }
        print(email)
        print(pass)
        let alertController = Alert()
        if(!email.isEmpty && !pass.isEmpty){
            Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                if error == nil && user != nil {
                    print("Logged in")
                    let alertController = UIAlertController(title: "Success", message: "Successfully logged in!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        print("ok?")
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
