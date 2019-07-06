//
//  ViewController.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 21/06/19.
//  Copyright © 2019 Antoine Lefevre All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    var ticTacToe = TicTacToe()
    @IBOutlet var lblStatus: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkConnection()
    }
    
    func checkConnection() {
        if Auth.auth().currentUser == nil {
            let signInViewController = SignInViewController.instantiate()
            self.present(signInViewController, animated: true)
        }
    }

    @IBAction func buttonTapped(sender: UIButton) {
        if sender.title(for: .normal) != "-" {
            return
        }
        var btnTextValue: String
        var btnBoardValue: Int
        switch ticTacToe.checkStatus() {
        case .xTern:
            btnTextValue = "X"
            btnBoardValue = 1
        case .oTern:
            btnTextValue = "O"
            btnBoardValue = 2
        default:
            btnTextValue = "-"
            btnBoardValue = 0
        }
        ticTacToe.board[(sender.tag-1)/3][(sender.tag-1)%3] = btnBoardValue
        sender.setTitle(btnTextValue, for: .normal)
        updateState()
    }

    @IBAction func btnResetTapped(sender: UIButton) {
        ticTacToe.resetBoard()
        for i in 1...9 {
            let btn = self.view.viewWithTag(i) as! UIButton
            btn.setTitle("-", for: .normal)
        }
        updateState()
    }

    func updateState() {
        lblStatus.text = ticTacToe.checkStatus().rawValue
    }

}

