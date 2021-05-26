//
//  HomeViewController.swift
//  MyPictIonis
//
//  Created by Boubakar Traore on 10/07/2018.
//  Copyright © 2018 Boubakar Traore. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Labels
    @IBOutlet weak var HomeWelcomeLabel: UILabel!
    @IBOutlet weak var HomeHostRoomLabel: UILabel!
    @IBOutlet weak var HomeNameLabel: UILabel!
    @IBOutlet weak var HomeFirstnameLabel: UILabel!
    @IBOutlet weak var HomePrivateLabel: UILabel!
    @IBOutlet weak var HomeJoinRoomLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var NewRoomNameTextfield: UITextField!
    @IBOutlet weak var NewRoomPasswordTextfield: UITextField!
    
    // Button
    @IBOutlet weak var HomeLogOutButton: UIButton!
    @IBOutlet weak var NewRoomPrivateSwitch: UISwitch!
    @IBOutlet weak var HomeCreateRoomButton: UIButton!
    @IBOutlet weak var MyProfileButton: UIButton!
    
    var roomList:[Room]
    var roomSearchingList:[Room]
    var currentUser: User
    var passWay: Bool
    var searching : Bool
    var wordIndex: Int
    
    var refRoom: FIRDatabaseReference?
    
    required init?(coder aDecoder: NSCoder) {
        roomList = [Room]()
        roomSearchingList = [Room]()
        currentUser = User()
        passWay = false
        searching = false
        wordIndex = Int(arc4random() % 10)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refRoom = FIRDatabase.database().reference()
        HomeFirstnameLabel.text = currentUser.getUsername()
        HomeWelcomeLabel.text = "HOME_MAINTITLE".localized()
        HomeHostRoomLabel.text = "HOME_TITLE_HOST".localized()
        HomeJoinRoomLabel.text = "HOME_TITLE_JOIN".localized()
        HomeNameLabel.text = "HOME_HOST_NAME".localized()
        HomePrivateLabel.text = "HOME_HOST_PRIVATE".localized()
        HomeLogOutButton.setTitle("LOGOUT".localized(), for: .normal)
        MyProfileButton.setTitle("MY_PROFIL".localized(), for: .normal)
        HomeCreateRoomButton.setTitle("HOME_BUTTON_CREATE".localized(), for: .normal)
        NewRoomPasswordTextfield.placeholder = "HOME_PASSWORD_HINT".localized()
        loadAllRooms()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        roomSearchingList = roomList.filter({$0.getTitle().lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return roomSearchingList.count
        } else {
            return roomList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentRoom : Room
        if searching {
            currentRoom = roomSearchingList[indexPath.row]
        } else {
            currentRoom = roomList[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        configureRoomCell(for: cell, with: currentRoom)
        if currentRoom.isActive() == false {
            cell.isUserInteractionEnabled = currentRoom.isActive()
            cell.backgroundColor = UIColor.brown
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentRoom = roomList[indexPath.row]
        
        if currentRoom.getPlayer2() == "-1" || currentRoom.getPlayer1() == currentUser.getUsername() {
            if currentRoom.getPlayer1() != currentUser.getUsername() {
                if currentRoom.getPassword() != "" {
                    let alert = UIAlertController(title: "HOME_PASSWORD_HINT".localized(), message: "", preferredStyle: .alert)
                    alert.addTextField { (textfield) in
                        textfield.placeholder = "ENTER_PASSWORD".localized()
                    }
                    alert.addAction(UIAlertAction(title: "VALIDATION".localized(), style: .default) { action in
                        var passEntered: String
                        passEntered = (alert.textFields?[0].text!)!
                        if passEntered == currentRoom.getPassword() {
                            if self.currentUser.getUsername() != currentRoom.getPlayer1() {
                                // Si c'est le deuxieme joueur qui tente d'entrer dans la room, mettre a jour la salle
                                currentRoom.setPlayer2(Number: self.currentUser.getUsername())
                                //currentRoom.setActive(bool: false)
                                updateRoom(reference: self.refRoom!, room: currentRoom, id: currentRoom.getId())
                            }
                            self.performSegue(withIdentifier: "RoomGameSegue", sender: currentRoom)
                        }
                    })
                    alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    currentRoom.setPlayer2(Number: self.currentUser.getUsername())
                    //currentRoom.setActive(bool: false)
                    updateRoom(reference: self.refRoom!, room: currentRoom, id: currentRoom.getId())
                    self.performSegue(withIdentifier: "RoomGameSegue", sender: currentRoom)
                }
            } else {
                self.performSegue(withIdentifier: "RoomGameSegue", sender: currentRoom)
            }
        } else {
            if currentRoom.getPlayer2() == currentUser.getUsername() {
                self.performSegue(withIdentifier: "RoomGameSegue", sender: currentRoom)
            } else {
            let alert = UIAlertController(title: "ROOM_FULL".localized(), message: "ROOM_FULL_MESSAGE".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil))
            self.present(alert, animated: true)
            }
        }
    }
    
    private func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoomGameSegue" {
            let newRoom: Room
            newRoom = sender as! Room
            var destination: RoomViewController
            destination = segue.destination as! RoomViewController
            destination.currentRoom = newRoom
            destination.currentUser = self.currentUser
        }
        if segue.identifier == "MyProfileSegue" {
            let newUser: User
            newUser = sender as! User
            var destination: InfosViewController
            destination = segue.destination as! InfosViewController
            destination.currentUser = newUser
        }
    }
    
    func configureRoomCell (for cell: UITableViewCell, with room: Room) {
        
        let title = cell.viewWithTag(1000) as! UILabel
        let host = cell.viewWithTag(1001) as! UILabel
        let hostlabel = cell.viewWithTag(1004) as! UILabel
        let playerslabel = cell.viewWithTag(1003) as! UILabel
        let numberOfPlayer = cell.viewWithTag(1002) as! UILabel
        
        hostlabel.text = "HOME_ROOM_HOST".localized()
        playerslabel.text = "HOME_ROOM_PLAYERS".localized()
        title.text = room.getTitle()
        host.text = room.getPlayer1()
        numberOfPlayer.text = room.getPlayer2() != "-1" ? "2" : "1"
    }
    
    func resetFields () {
        NewRoomPasswordTextfield.text = ""
        NewRoomPrivateSwitch.setOn(false, animated: true)
        NewRoomNameTextfield.text = ""
    }
    
    
    @IBAction func myInfos(_ sender: UIButton) {
        performSegue(withIdentifier: "MyProfileSegue", sender: currentUser)
    }
    
    @IBAction func createNewRoom(_ sender: Any) {
        
        var newRoom: Room
        var titleOfRoom: String
        var passwordOfRoom: String
        
        if NewRoomNameTextfield.text != "" {
            if NewRoomPrivateSwitch.isOn {
                if NewRoomPasswordTextfield.text != "" {
                    titleOfRoom = NewRoomNameTextfield.text!
                    passwordOfRoom = NewRoomPasswordTextfield.text!
                    let key = refRoom!.childByAutoId().key
                    newRoom = Room(Id: key, Title: titleOfRoom, Player1: self.currentUser.getUsername(), Password: passwordOfRoom)
                    newRoom.setWordIndex(Index: wordIndex)
                    updateRoom(reference: refRoom!, room: newRoom, id: key)
                    resetFields()
                    performSegue(withIdentifier: "RoomGameSegue", sender: newRoom)
                } else {
                    let alert = UIAlertController(title: "ERROR".localized(), message: "ERROR_PASSWORD_PRIVATE".localized(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            } else {
                titleOfRoom = NewRoomNameTextfield.text!
                let key = refRoom!.childByAutoId().key
                newRoom = Room(Id: key, Title: titleOfRoom, Player1: self.currentUser.getUsername(), Password: "")
                newRoom.setWordIndex(Index: wordIndex)
                updateRoom(reference: refRoom!, room: newRoom, id: key)
                resetFields()
                performSegue(withIdentifier: "RoomGameSegue", sender: newRoom)
            }
        } else {
            resetFields()
            let alert = UIAlertController(title: "ERROR".localized(), message: "ERROR_TITLE".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    func loadAllRooms() {
        refRoom?.child("Room").observe(FIRDataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.roomList.removeAll()
                for rooms in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    let roomObject = rooms.value as! [String: Any]
                    
                    let roomTitle = roomObject["Title"] as! String
                    let roomPlayer1 = roomObject["Player1"] as! String
                    let roomPlayer2 = roomObject["Player2"] as! String
                    let roomPlayed = roomObject["Played"] as! Bool
                    let roomWinner = roomObject["Winner"] as! String
                    let roomActive = roomObject["Active"] as! Bool
                    let roomPassword = roomObject["Password"] as! String
                    let roomId = roomObject["Id"] as! String
                    let roomTurn = roomObject["Turn"] as! Int
                    let roomWordIndex = roomObject["WordIndex"] as! Int
                    
                    let room = Room(Id: roomId, Title: roomTitle , Player1: roomPlayer1 , Player2: roomPlayer2, Played: roomPlayed , Winner: roomWinner, Active: roomActive , Password: roomPassword, Turn: roomTurn, WordIndex: roomWordIndex)
                    
                    self.roomList.append(room)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func LogOut(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        self.performSegue(withIdentifier: "BackLogin", sender: nil)
    }
    
    
}
