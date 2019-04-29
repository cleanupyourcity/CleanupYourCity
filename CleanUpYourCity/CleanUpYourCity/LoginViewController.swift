//
//  LoginViewController.swift
//  CleanUpYourCity
//
//  Created by Emmanuel Guido on 4/14/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onLoginButton(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homePage = storyboard.instantiateViewController(withIdentifier: "homeView")
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if(error != nil)
            {
                print(error!)
            }
            else
            {
                print("Login succesful")
                self.present(homePage, animated:true, completion:nil)
            }
        }
    }
    
    
    
}
