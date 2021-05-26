//
//  User.swift
//  MyPictIonis
//
//  Created by Boubakar Traore on 12/07/2018.
//  Copyright © 2018 Boubakar Traore. All rights reserved.
//

import Foundation

class User {
    
    private var _id:String
    private var _firstname: String
    private var _lastname: String
    private var _username: String
    private var _email: String
    private var _password: String
    
    
    // Constructeurs
    
    init () {
        self._id = ""
        self._firstname = ""
        self._lastname = ""
        self._username = ""
        self._email = ""
        self._password = ""
    }
    
    init(Id: String, Firstname: String, Lastname: String, Username: String, Email: String, Password: String) {
        self._id = Id
        self._firstname = Firstname
        self._lastname = Lastname
        self._username = Username
        self._email = Email
        self._password = Password
    }
    
    // Firstname
    func getFirstname() -> String {
        return self._firstname
    }
    
    func setFirstname(Name: String) {
        self._firstname = Name
    }
    
    // Lastname
    func getLastname() -> String {
        return self._lastname
    }
    
    func setLastname(Name: String) {
        self._lastname = Name
    }
    
    // Username
    func getUsername() -> String {
        return self._username
    }
    
    func setUsername(Name: String) {
        self._username = Name
    }
    
    // Email
    func getEmail() -> String {
        return self._email
    }
    
    func setEmail(Mail: String) {
        self._email = Mail
    }
    
    // Mot de Passe
    func getPassword() -> String {
        return self._password
    }
    
    func setPassword(Password: String) {
        self._password = Password
    }
    
    // Id
    
    func getId() -> String {
        return self._id
    }
    
    func setId(Id: String) {
        self._id = Id
    }
    
    
}
