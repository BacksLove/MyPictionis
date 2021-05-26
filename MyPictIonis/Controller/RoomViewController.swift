//
//  RoomViewController.swift
//  MyPictIonis
//
//  Created by Boubakar Traore on 16/07/2018.
//  Copyright © 2018 Boubakar Traore. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatTableView: UITableView!

    @IBOutlet weak var RoomTurnLabel: UILabel!
    @IBOutlet weak var WordToFindLabel: UILabel!
    @IBOutlet weak var RoomBackButton: UIButton!
    
    @IBOutlet weak var RoomResponseTextfield: UITextField!
    @IBOutlet weak var RoomChatTextfield: UITextField!
    
    @IBOutlet weak var RoomChatSendButton: UIButton!
    @IBOutlet weak var RoomResetButton: UIButton!
    
    @IBOutlet weak var RoomLetter1Button: UIButton!
    @IBOutlet weak var RoomLetter2Button: UIButton!
    @IBOutlet weak var RoomLetter3Button: UIButton!
    @IBOutlet weak var RoomLetter4Button: UIButton!
    @IBOutlet weak var RoomLetter5Button: UIButton!
    @IBOutlet weak var RoomLetter6Button: UIButton!
    @IBOutlet weak var RoomLetter7Button: UIButton!
    @IBOutlet weak var RoomLetter8Button: UIButton!
    @IBOutlet weak var RoomLetter9Button: UIButton!
    @IBOutlet weak var RoomLetter10Button: UIButton!
    @IBOutlet weak var RoomLetter11Button: UIButton!
    @IBOutlet weak var RoomLetter12Button: UIButton!
    
    private var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    private var drawRef: FIRDatabaseReference = FIRDatabase.database().reference(withPath: "Drawing")
    private var drawRefHandle: FIRDatabaseHandle?
    
    private var lastPoint = CGPoint.zero
    private var swiped = false
    
    private var red:CGFloat = 44/255
    private var green:CGFloat = 62/255
    private var blue:CGFloat = 80/255
    
    private var currentColor:NSNumber = 6;
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var drawView: UIView!
    
    private var timer = Timer()
    
    var test: NSCoder
    
    var chatMessageList: [ChatMessage]
    private var responseList: [String]
    private var responseLetter: [Character] = [Character](repeating: "a", count: 12)
    private var counter: Int
    private var wichUser: Int
    private var turn: Int
    private var numberOfWord: UInt32
    private var numberOfLetters: Int
    
    var currentRoom: Room = Room()
    var currentUser: User = User()
    
    let colorsBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let redColor: UIButton = {
        let red = UIButton()
        red.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        red.backgroundColor = UIColor.red
        red.translatesAutoresizingMaskIntoConstraints = false
        red.layer.cornerRadius = 20
        red.layer.masksToBounds = true
        return red
    }()
    
    let blueColor: UIButton = {
        let red = UIButton()
        red.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        red.backgroundColor = UIColor.blue
        red.translatesAutoresizingMaskIntoConstraints = false
        red.layer.cornerRadius = 20
        red.layer.masksToBounds = true
        return red
    }()
    
    let yellowColor: UIButton = {
        let red = UIButton()
        red.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        red.backgroundColor = UIColor.yellow
        red.translatesAutoresizingMaskIntoConstraints = false
        red.layer.cornerRadius = 20
        red.layer.masksToBounds = true
        return red
    }()
    
    let orangeColor: UIButton = {
        let red = UIButton()
        red.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        red.backgroundColor = UIColor.orange
        red.translatesAutoresizingMaskIntoConstraints = false
        red.layer.cornerRadius = 20
        red.layer.masksToBounds = true
        return red
    }()
    
    let greenColor: UIButton = {
        let red = UIButton()
        red.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        red.backgroundColor = UIColor.green
        red.translatesAutoresizingMaskIntoConstraints = false
        red.layer.cornerRadius = 20
        red.layer.masksToBounds = true
        return red
    }()
    
    let lightBlueColor: UIButton = {
        let red = UIButton()
        red.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        red.backgroundColor = UIColor(red: 129/255, green: 207/255, blue: 224/255, alpha: 1)
        red.translatesAutoresizingMaskIntoConstraints = false
        red.layer.cornerRadius = 20
        red.layer.masksToBounds = true
        return red
    }()
    
    let blackColor: UIButton = {
        let red = UIButton()
        red.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        red.backgroundColor = UIColor.black
        red.translatesAutoresizingMaskIntoConstraints = false
        red.layer.cornerRadius = 20
        red.layer.masksToBounds = true
        return red
    }()
    
    required init?(coder aDecoder: NSCoder) {
        chatMessageList = [ChatMessage]()
        responseList = ["CHAUSSURE", "FAUTEUIL", "MAISON", "VOITURE", "CHAISE", "FEMME", "TELEPHONE", "ARBRE", "ORDINATEUR", "BOUTEILLE", "TELEVISION", "MAIN", "CROISSANT", "BOTTE", "NID", "BALLE", "BOUCHE"]
        counter = 0
        numberOfWord = UInt32(responseList.count)
        wichUser = 0
        turn = 0
        numberOfLetters = 12
        test = aDecoder
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RoomBackButton.setTitle("BACK".localized(), for: .normal)
        RoomChatSendButton.setTitle("SEND".localized(), for: .normal)
        RoomResetButton.setTitle("RESET".localized(), for: .normal)
        
        drawRef = FIRDatabase.database().reference(withPath: "Drawing").child(currentRoom.getId())
        view.addSubview(colorsBarView)
        if currentRoom.getPlayer1() == currentUser.getUsername() {
            wichUser = 1
        } else {
            wichUser = 2
        }
        turn = currentRoom.getTurn()
        loadAllMessage()
        setLetters()
        whosTurn()
        observeNewPoints()
        observeReset()
        observeMyTurn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        drawRef = FIRDatabase.database().reference(withPath: "Drawing").child(currentRoom.getId())
        view.addSubview(colorsBarView)
        if currentRoom.getPlayer1() == currentUser.getUsername() {
            wichUser = 1
        } else {
            wichUser = 2
        }
        turn = currentRoom.getTurn()
        loadAllMessage()
        setLetters()
        whosTurn()
        observeNewPoints()
        observeReset()
        observeMyTurn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.drawView)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentMessage = chatMessageList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        configureChatCell(for: cell, with: currentMessage)
        return cell
    }
    
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return IndexPath(row: 6, section: 0)
    }
    
    func configureChatCell (for cell: UITableViewCell, with chatMessage: ChatMessage) {
        let user = cell.viewWithTag(2001) as! UILabel
        let message = cell.viewWithTag(2002) as! UILabel
        user.text = chatMessage.getUser()
        message.text = chatMessage.getMessage()
        if user.text == currentRoom.getPlayer2() {
            user.textAlignment = .right
            message.textAlignment = .right
        } else {
            user.textAlignment = .left
            message.textAlignment = .left
        }
    }
    
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.drawView.frame.size)
        imageView?.image?.draw(in: CGRect(x: 0, y: 0, width: self.drawView.frame.width, height: self.drawView.frame.height))
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(2)
        context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: 1).cgColor)
        
        context?.strokePath()
        
        imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let newDrawRef = drawRef.childByAutoId()
        let fromPointX = NSNumber(value: Float(fromPoint.x))
        let fromPointY = NSNumber(value: Float(fromPoint.y))
        let toPointX = NSNumber(value: Float(toPoint.x))
        let toPointY = NSNumber(value: Float(toPoint.y))
        let drawInfo = Draw(fromPointX: fromPointX, fromPointY: fromPointY, toPointX: toPointX, toPointY: toPointY, color: currentColor)
        
        
        newDrawRef.setValue(drawInfo.toAnyObject())
    }
    
    func drawLineObserve(fromPoint: CGPoint, toPoint: CGPoint, color: NSNumber) {
        setRGB(color: color)
        UIGraphicsBeginImageContext(self.drawView.frame.size)
        imageView?.image?.draw(in: CGRect(x: 0, y: 0, width: self.drawView.frame.width, height: self.drawView.frame.height))
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(2)
        context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: 1).cgColor)
        
        context?.strokePath()
        
        imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first{
            let currentPoint = touch.location(in: self.drawView)
            drawLine(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    @IBAction func pickAColor(_ sender: Any) {
        if (sender as AnyObject).tag == 0{
            currentColor = 0;
            red = 231/255
            green = 76/255
            blue = 60/255
        }
        if (sender as AnyObject).tag == 1{
            currentColor = 1;
            red = 230/255
            green = 136/255
            blue = 34/255
        }
        if (sender as AnyObject).tag == 2{
            currentColor = 2;
            red = 241/255
            green = 196/255
            blue = 15/255
        }
        if (sender as AnyObject).tag == 3{
            currentColor = 3;
            red = 52/255
            green = 152/255
            blue = 219/255
        }
        if (sender as AnyObject).tag == 4{
            currentColor = 4;
            red = 46/255
            green = 204/255
            blue = 113/255
        }
        if (sender as AnyObject).tag == 5{
            currentColor = 5;
            red = 155/255
            green = 89/255
            blue = 182/255
        }
        if (sender as AnyObject).tag == 6{
            currentColor = 6;
            red = 44/255
            green = 62/255
            blue = 80/255
        }
    }
    
    func setRGB(color: NSNumber){
        if (color == 0){
            red = 231/255
            green = 76/255
            blue = 60/255
        }
        if (color == 1){
            red = 230/255
            green = 136/255
            blue = 34/255
        }
        if (color == 2){
            red = 241/255
            green = 196/255
            blue = 15/255
        }
        if (color == 3){
            red = 52/255
            green = 152/255
            blue = 219/255
        }
        if (color == 4){
            red = 46/255
            green = 204/255
            blue = 113/255
        }
        if (color == 5){
            red = 155/255
            green = 89/255
            blue = 182/255
        }
        if (color == 6){
            red = 44/255
            green = 62/255
            blue = 80/255
        }
    }
    
    @IBAction func Reset(_ sender: Any) {
        self.imageView.image = nil
        drawRef.removeValue()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped{
            drawLine(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    
    private func observeNewPoints(){
        drawRefHandle = drawRef.observe(.childAdded, with: { snapshot in
            let drawData = snapshot.value as! Dictionary<String, Double>
            
            let fromPointX = drawData["fromPointX"]
            let fromPointY = drawData["fromPointY"]
            let toPointX = drawData["toPointX"]
            let toPointY = drawData["toPointY"]
            let fromPoint = CGPoint(x: fromPointX!, y: fromPointY!)
            let toPoint = CGPoint(x: toPointX!, y: toPointY!)
            let colorFromData = drawData["color"]
            let nsColor = NSNumber(value: colorFromData!)
            
            self.drawLineObserve(fromPoint: fromPoint, toPoint: toPoint, color: nsColor)
        })
    }
    
    private func observeReset(){
        drawRefHandle = drawRef.observe(.childRemoved, with: { snapshot in
            self.imageView.image = nil
        })
    }
    
    private func observeMyTurn(){
        ref.child("Room").child(currentRoom.getId()).observe(.childChanged, with: { (snapshot) in
            print(snapshot)
            /*let alert = UIAlertController(title: "A votre tour de deviner", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)*/
            //self.WordToFindLabel.isHidden = true
            //self.whosTurn()
            self.performSegue(withIdentifier: "NextTurnSegue", sender: nil)
            })
    }
    
    @IBAction func GoBack(_ sender: Any) {
        self.performSegue(withIdentifier: "ReturnHome", sender: nil)
    }
    
    private func whosTurn() {
        ref.child("Room").child(currentRoom.getId()).observe(.value, with: { (snap) in
            if snap.childrenCount > 0 {
                let roomTake = snap.value as! [String: Any]
                
                let id = roomTake["Id"]
                let title = roomTake["Title"]
                let player1 = roomTake["Player1"]
                let player2 = roomTake["Player2"]
                let played = roomTake["Played"]
                let winner = roomTake["Winner"]
                let active = roomTake["Active"]
                let password = roomTake["Password"]
                let turn = roomTake["Turn"]
                let wordIndex = roomTake["WordIndex"]
                
                self.currentRoom = Room(Id: id! as! String, Title: title! as! String, Player1: player1! as! String, Player2: player2! as! String, Played: played! as! Bool, Winner: winner! as! String, Active: active! as! Bool, Password: password! as! String, Turn: turn! as! Int, WordIndex: wordIndex! as! Int)
            }
        })
        
        if currentRoom.getTurn() == 1 {
            if currentUser.getUsername() == currentRoom.getPlayer1() {
                RoomTurnLabel.text = "FIND_THE_WORD".localized()
                WordToFindLabel.isHidden = true
                enableLetters()
            } else {
                RoomTurnLabel.text = "DRAW_SOMETHING".localized()
                WordToFindLabel.text = responseList[currentRoom.getWordndex()]
                WordToFindLabel.isHidden = false
                disableLetters()
            }
        }
        if currentRoom.getTurn() == 2 {
            if currentUser.getUsername() == currentRoom.getPlayer2() {
                RoomTurnLabel.text = "FIND_THE_WORD".localized()
                WordToFindLabel.isHidden = true
                enableLetters()
            } else {
                RoomTurnLabel.text = "DRAW_SOMETHING".localized()
                WordToFindLabel.text = responseList[currentRoom.getWordndex()]
                WordToFindLabel.isHidden = false
                disableLetters()
            }
        }
    }
    
    // Erase all letters
    
    @IBAction func eraseLetters(_ sender: Any) {
        RoomResponseTextfield.text = ""
        RoomLetter1Button.isHidden = false
        RoomLetter2Button.isHidden = false
        RoomLetter3Button.isHidden = false
        RoomLetter4Button.isHidden = false
        RoomLetter5Button.isHidden = false
        RoomLetter6Button.isHidden = false
        RoomLetter7Button.isHidden = false
        RoomLetter8Button.isHidden = false
        RoomLetter9Button.isHidden = false
        RoomLetter10Button.isHidden = false
        RoomLetter11Button.isHidden = false
        RoomLetter12Button.isHidden = false
    }
    
    private func disableLetters() {
        RoomLetter1Button.isEnabled = false
        RoomLetter2Button.isEnabled = false
        RoomLetter3Button.isEnabled = false
        RoomLetter4Button.isEnabled = false
        RoomLetter5Button.isEnabled = false
        RoomLetter6Button.isEnabled = false
        RoomLetter7Button.isEnabled = false
        RoomLetter8Button.isEnabled = false
        RoomLetter9Button.isEnabled = false
        RoomLetter10Button.isEnabled = false
        RoomLetter11Button.isEnabled = false
        RoomLetter12Button.isEnabled = false
    }
    
    private func enableLetters() {
        RoomLetter1Button.isEnabled = true
        RoomLetter2Button.isEnabled = true
        RoomLetter3Button.isEnabled = true
        RoomLetter4Button.isEnabled = true
        RoomLetter5Button.isEnabled = true
        RoomLetter6Button.isEnabled = true
        RoomLetter7Button.isEnabled = true
        RoomLetter8Button.isEnabled = true
        RoomLetter9Button.isEnabled = true
        RoomLetter10Button.isEnabled = true
        RoomLetter11Button.isEnabled = true
        RoomLetter12Button.isEnabled = true
    }
    
    private func setLetters() {
        responseLetter = Array(responseList[currentRoom.getWordndex()])
        counter = responseList[currentRoom.getWordndex()].count
        while counter < numberOfLetters {
            let nbale: Int = Int(arc4random() % 26) + 65
            
            responseLetter.append(Character(UnicodeScalar(nbale)!))
            counter = counter + 1
        }
        responseLetter.shuffle()
        
        RoomLetter1Button.setTitle(String(responseLetter[0]), for: .normal)
        RoomLetter2Button.setTitle(String(responseLetter[1]), for: .normal)
        RoomLetter3Button.setTitle(String(responseLetter[2]), for: .normal)
        RoomLetter4Button.setTitle(String(responseLetter[3]), for: .normal)
        RoomLetter5Button.setTitle(String(responseLetter[4]), for: .normal)
        RoomLetter6Button.setTitle(String(responseLetter[5]), for: .normal)
        RoomLetter7Button.setTitle(String(responseLetter[6]), for: .normal)
        RoomLetter8Button.setTitle(String(responseLetter[7]), for: .normal)
        RoomLetter9Button.setTitle(String(responseLetter[8]), for: .normal)
        RoomLetter10Button.setTitle(String(responseLetter[9]), for: .normal)
        RoomLetter11Button.setTitle(String(responseLetter[10]), for: .normal)
        RoomLetter12Button.setTitle(String(responseLetter[11]), for: .normal)
    }
    
    @IBAction func pickALetter(_ sender: Any) {
        if (sender as AnyObject).tag == 30{
            RoomResponseTextfield.text = RoomResponseTextfield.text! + "" + (RoomLetter1Button.titleLabel?.text!)!
            RoomLetter1Button.isHidden = true
        }
        if (sender as AnyObject).tag == 31{
            RoomResponseTextfield.text = RoomResponseTextfield.text! + "" + (RoomLetter2Button.titleLabel?.text!)!
            RoomLetter2Button.isHidden = true
        }
        if (sender as AnyObject).tag == 32{
            RoomResponseTextfield.text = RoomResponseTextfield.text! + "" + (RoomLetter3Button.titleLabel?.text!)!
            RoomLetter3Button.isHidden = true
        }
        if (sender as AnyObject).tag == 33{
            RoomResponseTextfield.text = RoomResponseTextfield.text! + "" + (RoomLetter4Button.titleLabel?.text!)!
            RoomLetter4Button.isHidden = true
        }
        if (sender as AnyObject).tag == 34{
            RoomResponseTextfield.text = RoomResponseTextfield.text! + "" + (RoomLetter5Button.titleLabel?.text!)!
            RoomLetter5Button.isHidden = true
        }
        if (sender as AnyObject).tag == 35{
            RoomResponseTextfield.text = RoomResponseTextfield.text! + "" + (RoomLetter6Button.titleLabel?.text!)!
            RoomLetter6Button.isHidden = true
        }
        if (sender as AnyObject).tag == 36{
            RoomResponseTextfield.text = RoomResponseTextfield.text! + "" + (RoomLetter7Button.titleLabel?.text!)!
            RoomLetter7Button.isHidden = true
        }
        if (sender as AnyObject).tag == 37{
            RoomResponseTextfield.text = RoomResponseTextfield.text! + "" + (RoomLetter8Button.titleLabel?.text!)!
            RoomLetter8Button.isHidden = true
        }
        if (sender as AnyObject).tag == 38{
            RoomResponseTextfield.text = RoomResponseTextfield.text! + "" + (RoomLetter9Button.titleLabel?.text!)!
            RoomLetter9Button.isHidden = true
        }
        if (sender as AnyObject).tag == 39{
            RoomResponseTextfield.text = RoomResponseTextfield.text! + "" + (RoomLetter10Button.titleLabel?.text!)!
            RoomLetter10Button.isHidden = true
        }
        if (sender as AnyObject).tag == 40{
            RoomResponseTextfield.text = RoomResponseTextfield.text! + "" + (RoomLetter11Button.titleLabel?.text!)!
            RoomLetter11Button.isHidden = true
        }
        if (sender as AnyObject).tag == 41{
            RoomResponseTextfield.text = RoomResponseTextfield.text! + "" + (RoomLetter12Button.titleLabel?.text!)!
            RoomLetter12Button.isHidden = true
        }
        // Check si la réponse est correcte
        if currentRoom.getTurn() == 1 && responseList[currentRoom.getWordndex()] == RoomResponseTextfield.text {
            let alert = UIAlertController(title: "CONGRAT".localized(), message: "CORRECT_ANSWER".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            currentRoom.setTurn(Turn: 2)
            currentRoom.setWordIndex(Index: Int(arc4random() % numberOfWord))
            updateRoom(reference: ref, room: currentRoom, id: currentRoom.getId())
            setLetters()
            eraseLetters(Any?.self)
            self.imageView.image = nil
            drawRef.removeValue()
            observeReset()
            whosTurn()
        } else
            if currentRoom.getTurn() == 2 && responseList[currentRoom.getWordndex()] == RoomResponseTextfield.text {
                let alert = UIAlertController(title: "CONGRAT".localized(), message: "CORRECT_ANSWER".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                currentRoom.setTurn(Turn: 1)
                currentRoom.setWordIndex(Index: Int(arc4random() % numberOfWord))
                updateRoom(reference: ref, room: currentRoom, id: currentRoom.getId())
                setLetters()
                eraseLetters(Any?.self)
                self.imageView.image = nil
                drawRef.removeValue()
                observeReset()
                whosTurn()
                }
    }
    
    @IBAction func SendMessage(_ sender: Any) {
        if RoomChatTextfield.text != "" {
            let key = ref.childByAutoId().key
            let currentMessage = ChatMessage(id: key, idRoom: currentRoom.getId(), idUser: currentUser.getUsername(), message: RoomChatTextfield.text!)
            addMessage(reference: ref, message: currentMessage, id: currentRoom.getId())
            RoomChatTextfield.text = ""
            loadAllMessage()
        }
    }
    
    func loadAllMessage() {
        ref.child("Chat").child(currentRoom.getId()).observe(.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.chatMessageList.removeAll()
                for messages in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    let messageObject = messages.value as! [String: Any]
                    
                    let messageId = messageObject["Id"] as! String
                    let messageText = messageObject["Message"] as! String
                    let messageRoom = messageObject["RoomId"] as! String
                    let messageUser = messageObject["User"] as! String
                    
                    let currentMessage = ChatMessage(id: messageId, idRoom: messageRoom, idUser: messageUser, message: messageText)
                    
                    self.chatMessageList.append(currentMessage)
                }
                self.chatTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NextTurnSegue" {
            var destination: NextTurnViewController
            destination = segue.destination as! NextTurnViewController
            destination.currentUser = self.currentUser
            destination.currentRoom = self.currentRoom
        }
        if segue.identifier == "ReturnHome" {
            var destination: HomeViewController
            destination = segue.destination as! HomeViewController
            destination.currentUser = self.currentUser
        }
    }

}
