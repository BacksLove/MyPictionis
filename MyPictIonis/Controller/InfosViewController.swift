//
//  InfosViewController.swift
//  MyPictIonis
//
//  Created by Boubakar Traore on 16/07/2018.
//  Copyright © 2018 Boubakar Traore. All rights reserved.
//

import UIKit
import Firebase

class InfosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var InfosLastnameTextfield: UITextField!
    @IBOutlet weak var InfosFirstnameTextfield: UITextField!
    @IBOutlet weak var InfosUsernameTextfield: UITextField!
    @IBOutlet weak var InfosEmailTextfield: UITextField!
    @IBOutlet weak var InfosPasswordTextfield: UITextField!
    
    @IBOutlet weak var InfosLastnameLabel: UILabel!
    @IBOutlet weak var InfosFirstnameLabel: UILabel!
    @IBOutlet weak var InfosUsernameLabel: UILabel!
    @IBOutlet weak var InfosEmailLabel: UILabel!
    @IBOutlet weak var InfosPasswordLabel: UILabel!
    
    @IBOutlet weak var InfosTitleLabel: UILabel!
    @IBOutlet weak var InfosTableTitleLabel: UILabel!
    
    @IBOutlet weak var ModifyButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    
    var currentUser: User
    var roomList:[Room]
    
    var dataRef: FIRDatabaseReference?
    
    required init?(coder aDecoder: NSCoder) {
        currentUser = User()
        roomList = [Room]()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        InfosFirstnameTextfield.text = currentUser.getFirstname()
        InfosLastnameTextfield.text = currentUser.getLastname()
        InfosUsernameTextfield.text = currentUser.getUsername()
        InfosEmailTextfield.text = currentUser.getEmail()
        InfosPasswordTextfield.text = currentUser.getPassword()
        
        InfosFirstnameLabel.text = "REGISTER_FIRSTNAME".localized()
        InfosLastnameLabel.text = "REGISTER_LASTNAME".localized()
        InfosEmailLabel.text = "REGISTER_EMAIL".localized()
        InfosUsernameLabel.text = "REGISTER_USERNAME".localized()
        InfosPasswordLabel.text = "REGISTER_PASSWORD".localized()
        InfosTitleLabel.text = "INFOS_TITLE".localized()
        InfosTableTitleLabel.text = "INFOS_TITLE_TABLE".localized()
        
        ModifyButton.setTitle("INFOS_MODIFY_BUTTON".localized(), for: .normal)
        
        InfosUsernameTextfield.backgroundColor = UIColor.lightGray
        InfosEmailTextfield.backgroundColor = UIColor.lightGray
        
        dataRef = FIRDatabase.database().reference()
        loadMyRooms()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentRoom : Room
        currentRoom = roomList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyRoomCell", for: indexPath)
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
                    let alert = UIAlertController(title: "Password", message: "", preferredStyle: .alert)
                    alert.addTextField { (textfield) in
                        textfield.placeholder = "Enter the password"
                    }
                    alert.addAction(UIAlertAction(title: "Validation", style: .default) { action in
                        var passEntered: String
                        passEntered = (alert.textFields?[0].text!)!
                        if passEntered == currentRoom.getPassword() {
                            if self.currentUser.getUsername() != currentRoom.getPlayer1() {
                                // Si c'est le deuxieme joueur qui tente d'entrer dans la room, mettre a jour la salle
                                currentRoom.setPlayer2(Number: self.currentUser.getUsername())
                                //currentRoom.setActive(bool: false)
                            }
                            self.performSegue(withIdentifier: "RoomGameSegue2", sender: currentRoom)
                        }
                    })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    currentRoom.setPlayer2(Number: self.currentUser.getUsername())
                    //currentRoom.setActive(bool: false)
                    self.performSegue(withIdentifier: "RoomGameSegue2", sender: currentRoom)
                }
            } else {
                self.performSegue(withIdentifier: "RoomGameSegue2", sender: currentRoom)
            }
        } else {
            if currentRoom.getPlayer2() == currentUser.getUsername() {
                self.performSegue(withIdentifier: "RoomGameSegue2", sender: currentRoom)
            } else {
                let alert = UIAlertController(title: "Room full", message: "This room is full of player", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    func configureRoomCell (for cell: UITableViewCell, with room: Room) {
        
        let title = cell.viewWithTag(5000) as! UILabel
        let host = cell.viewWithTag(5002) as! UILabel
        let hostlabel = cell.viewWithTag(5001) as! UILabel
        let playerslabel = cell.viewWithTag(5003) as! UILabel
        let numberOfPlayer = cell.viewWithTag(5004) as! UILabel
        
        hostlabel.text = "HOME_ROOM_HOST".localized()
        playerslabel.text = "HOME_ROOM_PLAYERS".localized()
        title.text = room.getTitle()
        host.text = room.getPlayer1()
        numberOfPlayer.text = room.getPlayer2() != "-1" ? "2" : "1"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoomGameSegue2" {
            let newRoom: Room
            newRoom = sender as! Room
            var destination: RoomViewController
            destination = segue.destination as! RoomViewController
            destination.currentRoom = newRoom
            destination.currentUser = self.currentUser
        }
    }
    
    func checkFields () -> Bool {
        
        if InfosFirstnameTextfield.text == currentUser.getFirstname() &&
            InfosLastnameTextfield.text == currentUser.getLastname() &&
            InfosUsernameTextfield.text == currentUser.getUsername() &&
            InfosEmailTextfield.text == currentUser.getEmail() &&
            InfosPasswordTextfield.text == currentUser.getPassword() {
            
            let alert = UIAlertController(title: "ERROR".localized() , message: "CHANGE_FIELDS".localized() , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized() , style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return false
        } else {
            return true
        }
    }
    
    
    @IBAction func ModifyInfos(_ sender: Any) {
        if checkFields() {
            let firstname = InfosFirstnameTextfield.text
            let lastname = InfosLastnameTextfield.text
            let email = InfosEmailTextfield.text
            let password = InfosPasswordTextfield.text
            let username = InfosUsernameTextfield.text
            
            let newUser = ["Id": currentUser.getId() , "Firstname": firstname, "Lastname": lastname, "Username": username, "Email": email, "Password": password]
            dataRef?.child("Users").child(currentUser.getId()).setValue(newUser)
            if password != currentUser.getPassword() {
                FIRAuth.auth()?.currentUser?.updatePassword(password!, completion: nil)
            }
            currentUser = User(Id: currentUser.getId(), Firstname: firstname!, Lastname: lastname!, Username: username!, Email: email!, Password: password!)
            let alert = UIAlertController(title: "DONE".localized() , message: "INFOS_SUCCESS_MESSAGE".localized() , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func loadMyRooms() {
        dataRef?.child("Room").observe(FIRDataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.roomList.removeAll()
                for rooms in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    let roomObject = rooms.value as! [String: Any]
                    
                    let roomPlayer1 = roomObject["Player1"] as! String
                    let roomPlayer2 = roomObject["Player2"] as! String
                    
                    if roomPlayer1 == self.currentUser.getUsername() || roomPlayer2 == self.currentUser.getUsername() {
                    
                        let roomTitle = roomObject["Title"] as! String
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
                    
                }
                self.tableview.reloadData()
            }
        }
    }
    
    @IBAction func GoBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
