//
//  File.swift
//  MyPictIonis
//
//  Created by Boubakar Traore on 31/07/2018.
//  Copyright © 2018 Boubakar Traore. All rights reserved.
//

import Foundation

class ChatMessage {
    private var _id: String
    private var _idRoom : String
    private var _user : String
    private var _message : String
    
    init () {
        self._id = ""
        self._idRoom = ""
        self._user = ""
        self._message = ""
    }
    
    init (id: String, idRoom: String, idUser: String, message: String) {
        self._id = id
        self._idRoom = idRoom
        self._user = idUser
        self._message = message
    }
    
    func getId () -> String {
        return self._id
    }
    
    func getIdRoom () -> String {
        return self._idRoom
    }
    
    func getUser () -> String {
        return self._user
    }
    
    func getMessage () -> String {
        return self._message
    }
    
    func setId (Id: String) {
        self._id = Id
    }
    
    func setUser (idUser: String) {
        self._user = idUser
    }
    
}
