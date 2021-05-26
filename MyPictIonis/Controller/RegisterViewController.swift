//
//  RegisterViewController.swift
//  MyPictIonis
//
//  Created by Boubakar Traore on 09/07/2018.
//  Copyright © 2018 Boubakar Traore. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    // Labels
    @IBOutlet weak var RegisterLastnameLabel: UILabel!
    @IBOutlet weak var RegisterFirstnameLabel: UILabel!
    @IBOutlet weak var RegisterUsernameLabel: UILabel!
    @IBOutlet weak var RegisterEmailLabel: UILabel!
    @IBOutlet weak var RegisterPasswordLabel: UILabel!
    @IBOutlet weak var RegisterErrorLabel: UILabel!
    @IBOutlet weak var RegisterTitleLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var RegisterLastnameTextfield: UITextField!
    @IBOutlet weak var RegisterFirstnameTextfield: UITextField!
    @IBOutlet weak var RegisterUsernameTextfield: UITextField!
    @IBOutlet weak var RegisterEmailTextfield: UITextField!
    @IBOutlet weak var RegisterPasswordTextfield: UITextField!
    
    // Button
    @IBOutlet weak var RegisterButton: UIButton!
    
    
    var ref: FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        RegisterTitleLabel.text = "REGISTER_TITLE".localized()
        RegisterErrorLabel.text = "REGISTER_ERROR".localized()
        RegisterLastnameLabel.text = "REGISTER_LASTNAME".localized()
        RegisterFirstnameLabel.text = "REGISTER_FIRSTNAME".localized()
        RegisterEmailLabel.text = "REGISTER_EMAIL".localized()
        RegisterUsernameLabel.text = "REGISTER_USERNAME".localized()
        RegisterPasswordLabel.text = "REGISTER_PASSWORD".localized()
        RegisterButton.setTitle("REGISTER_BUTTON".localized(), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func SignIn(_ sender: UIButton) {
        
        let email = RegisterEmailTextfield.text!
        let password = RegisterPasswordTextfield.text!
        let firstname = RegisterFirstnameTextfield.text!
        let lastname = RegisterLastnameTextfield.text!
        let username = RegisterUsernameTextfield.text!
        
        if email != "" && password != "" && firstname != "" && lastname != "" && username != "" {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if user != nil {
                    let key = user?.uid
                    let currentUser = User(Id: key!, Firstname: firstname, Lastname: lastname, Username: username, Email: email, Password: password)
                    let currentUserArray = ["Id": key!, "Firstname": firstname, "Lastname": lastname, "Username": username, "Email": email, "Password": password]
                    self.ref?.child("Users").child(key!).setValue(currentUserArray)
                    self.performSegue(withIdentifier: "RegisterSegue", sender: currentUser)
                }
            })
        }
        else {
            RegisterPasswordTextfield.text = ""
            RegisterErrorLabel.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegisterSegue" {
            let user = sender as! User
            var controller: HomeViewController
            controller = segue.destination as! HomeViewController
            controller.currentUser = user
        }
    }
    
    @IBAction func GoBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
