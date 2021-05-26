//
//  DataTestViewController.swift
//  MyPictIonis
//
//  Created by Boubakar Traore on 16/07/2018.
//  Copyright © 2018 Boubakar Traore. All rights reserved.
//

import UIKit

class DataTestViewController: UIViewController {
    
    @IBOutlet weak var TitreLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    
    var testRoom:Room = Room()

    override func viewDidLoad() {
        super.viewDidLoad()

        TitreLabel.text = testRoom.getTitle()
        playerLabel.text = String(testRoom.getPlayer1())
        
        print(testRoom.getTitle())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentMessage = chatMessageList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        configureChatCell(for: cell, with: currentMessage)
        return cell
    }
    
    func configureChatCell (for cell: UITableViewCell, with chatMessage: ChatMessage) {
        let user = cell.viewWithTag(2001) as! UILabel
        let message = cell.viewWithTag(2002) as! UILabel
        user.text = chatMessage.getUser()
        message.text = chatMessage.getMessage()
    }*/

}
