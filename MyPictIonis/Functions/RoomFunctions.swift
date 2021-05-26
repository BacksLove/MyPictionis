//
//  RoomFunctions.swift
//  MyPictIonis
//
//  Created by Boubakar Traore on 23/07/2018.
//  Copyright © 2018 Boubakar Traore. All rights reserved.
//

import Foundation
import FirebaseDatabase

func updateRoom(reference: FIRDatabaseReference, room: Room, id: String) {
    let newRoom = ["Id": id,
                    "Title": room.getTitle(),
                    "Player1": room.getPlayer1(),
                    "Player2": room.getPlayer2(),
                    "Played": room.getPlayed(),
                    "Winner": room.getWinner(),
                    "Active": room.isActive(),
                    "Password": room.getPassword(),
                    "Turn": room.getTurn(),
                    "WordIndex": room.getWordndex()] as [String : Any]
    
    reference.child("Room").child(id).setValue(newRoom)
}

func addMessage(reference: FIRDatabaseReference, message: ChatMessage, id: String) {
    let newMessage = ["Id": message.getId(),
                      "User": message.getUser(),
                      "RoomId": message.getId(),
                      "Message": message.getMessage()] as [String : Any]
    
    reference.child("Chat").child(id).childByAutoId().setValue(newMessage)
}

func deleteRoom(reference: FIRDatabaseReference, id:String) {
    reference.child("Room").child(id).removeValue()
}

