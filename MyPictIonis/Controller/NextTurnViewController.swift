//
//  NextTurnViewController.swift
//  MyPictIonis
//
//  Created by Boubakar Traore on 06/09/2018.
//  Copyright © 2018 Boubakar Traore. All rights reserved.
//

import UIKit

class NextTurnViewController: UIViewController {
    
    var currentRoom: Room = Room()
    var currentUser: User = User()
    
    var timer = Timer()

    @IBOutlet weak var YourTurnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YourTurnLabel.text = "YOUR_TURN".localized()
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(NextTurnViewController.returnFunc), userInfo: nil, repeats: false)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReturnSegue" {
            var destination : RoomViewController
            destination = segue.destination as! RoomViewController
            destination.currentRoom = self.currentRoom
            destination.currentUser = self.currentUser
        }
    }
    
    @objc func returnFunc () {
        self.performSegue(withIdentifier: "ReturnSegue", sender: nil)
    }
    
    
    @IBAction func Gooo(_ sender: Any) {
        
        self.performSegue(withIdentifier: "ReturnSegue", sender: nil)
        
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
