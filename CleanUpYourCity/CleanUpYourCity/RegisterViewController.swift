//
//  RegisterViewController.swift
//  CleanUpYourCity
//
//  Created by Emmanuel Guido on 4/17/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
    }
    
    @IBAction func onRegisterButton(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginPage = storyboard.instantiateViewController(withIdentifier: "loginView")
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if(error != nil)
            {
                print(error!)
                self.errorLabel.isHidden = false
                // self.errorLabel.text = error as? String
            }
            else
            {
                print("Registration succesful!")
                
                let user = Auth.auth().currentUser?.uid
                ref.child("profile").child(user!).setValue(["username":self.usernameTextField.text])
                
            }
            self.present(loginPage, animated:true, completion:nil)
        }
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backButton", sender: self)
    }
    
}
