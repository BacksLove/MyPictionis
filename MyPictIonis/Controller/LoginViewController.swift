//
//  ViewController.swift
//  MyPictIonis
//
//  Created by Boubakar Traore on 04/07/2018.
//  Copyright © 2018 Boubakar Traore. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    // Labels
    @IBOutlet weak var LoginLabel: UILabel!
    @IBOutlet weak var LoginPasswordLabel: UILabel!
    @IBOutlet weak var LoginErrorLabel: UILabel!
    @IBOutlet weak var LoginTitle: UILabel!
    
    // Textfields
    @IBOutlet weak var LoginTextfield: UITextField!
    @IBOutlet weak var LoginPasswordTextfield: UITextField!
    
    // Buttons
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    
    
    var ref: FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        LoginLabel.text = "LOGIN_MAIL".localized()
        LoginPasswordLabel.text = "LOGIN_PASSWORD".localized()
        LoginErrorLabel.text = "LOGIN_ERROR".localized()
        LoginTitle.text = "LOGIN_TITLE".localized()
        LoginButton.setTitle("LOGIN_BUTTON".localized(), for: .normal)
        RegisterButton.setTitle("LOGIN_REGISTER_BUTTON".localized(), for: .normal)
        LoginTextfield.placeholder = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func Login(_ sender: UIButton) {
        if let email = LoginTextfield.text , let password = LoginPasswordTextfield.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if user != nil {
                    let uid = user?.uid
                    self.ref?.child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                        print (snapshot)
                        let snapUser = snapshot.value as! [String: Any]
                        
                        let firstname = snapUser["Firstname"] as! String
                        let email = snapUser["Email"] as! String
                        let password = snapUser["Password"] as! String
                        let username = snapUser["Username"] as! String
                        let lastname = snapUser["Lastname"] as! String
                        
                        let newUser:User = User(Id: uid!, Firstname: firstname, Lastname: lastname, Username: username, Email: email, Password: password)
                        
                        self.performSegue(withIdentifier: "LogInSegue", sender: newUser)
                    })
                } else {
                    self.LoginErrorLabel.isHidden = false
                    self.LoginTextfield.text = ""
                    self.LoginPasswordTextfield.text = ""
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogInSegue" {
            var controller:HomeViewController
            controller = segue.destination as! HomeViewController
            controller.currentUser = sender as! User
        }
    }
}

