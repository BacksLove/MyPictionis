//
//  Room.swift
//  MyPictIonis
//
//  Created by Boubakar Traore on 11/07/2018.
//  Copyright © 2018 Boubakar Traore. All rights reserved.
//

import Foundation

class Room {
    
    private var _id: String
    private var _title:String
    private var _active:Bool
    private var _player1:String
    private var _player2:String
    private var _played:Bool
    private var _winner:String
    private var _password:String
    private var _turn:Int
    private var _wordIndex:Int
    
    // Constructeur
    
    init() {
        self._id = ""
        self._title = ""
        self._player1 = ""
        self._player2 = "-1"
        self._played = false
        self._winner = ""
        self._active = true
        self._password = ""
        self._turn = 1
        self._wordIndex = 0
    }
    
    init(Id: String, Title: String, Player1: String, Password: String) {
        self._id = Id
        self._title = Title
        self._player1 = Player1
        self._player2 = "-1"
        self._played = false
        self._winner = ""
        self._active = true
        self._password = Password
        self._turn = 1
        self._wordIndex = 0
    }
    
    init(Id: String, Title: String, Player1: String, Player2: String, Played: Bool, Winner: String, Active: Bool, Password: String, Turn: Int, WordIndex: Int) {
        self._id = Id
        self._title = Title
        self._player1 = Player1
        self._player2 = Player2
        self._played = Played
        self._winner = Winner
        self._active = Active
        self._password = Password
        self._turn = Turn
        self._wordIndex = WordIndex
    }
    
    func getTitle() -> String {
        return self._title
    }
    
    func setTitle(Name: String) {
        self._title = Name
    }
    
    func getPlayer1() -> String {
        return self._player1
    }
    
    func setPlayer1(Number: String) {
        self._player1 = Number
    }
    
    func getPlayer2() -> String {
        return self._player2
    }
    
    func setPlayer2(Number: String) {
        self._player2 = Number
    }
    
    func getPlayed() -> Bool {
        return self._played
    }
    
    func setPlayed(Number: Bool) {
        self._played = Number
    }
    
    func getWinner() -> String {
        return self._winner
    }
    
    func setWinner(Win: String) {
        self._winner = Win
    }
    
    func getPassword() -> String {
        return self._password
    }
    
    func setPassword(Pass: String) {
        self._password = Pass
    }
    
    func getId() -> String {
        return self._id
    }
    
    func isActive() -> Bool {
        return self._active
    }
    
    func setActive (bool: Bool) {
        self._active = bool
    }
    
    func getTurn() -> Int {
        return self._turn
    }
    
    func setTurn(Turn: Int) {
        self._turn = Turn
    }
    
    func getWordndex() -> Int {
        return self._wordIndex
    }
    
    func setWordIndex(Index: Int) {
        self._wordIndex = Index
    }
    
}
