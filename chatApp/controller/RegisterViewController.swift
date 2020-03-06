//
//  RegisterViewController.swift
//  chatApp
//
//  Created by Ajay Vandra on 1/23/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerBtnPressed(_ sender: Any) {
//        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailTextField.text! , password: passwordTextField.text!) { (user, error) in
            if error != nil{
                print(error!)
            }
            else{
                print("registration successful!")
//                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            
        }
    }
}
