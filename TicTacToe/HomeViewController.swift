//
//  HomeViewController.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 06/07/2019.
//  Copyright © 2019 Punchh Inc. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var ratioLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func playOnline(_ sender: Any) {
        if !self.checkConnection() { return }
        self.present(GameViewController.instantiate(gameMode: .online), animated: true)
    }
    
    @IBAction func playOffline(_ sender: Any) {
        self.present(GameViewController.instantiate(gameMode: .offline), animated: true)
    }
    
    func checkConnection() -> Bool {
        if Auth.auth().currentUser == nil {
            let signInViewController = SignInViewController.instantiate()
            self.present(signInViewController, animated: true)
            return false
        }
        return true
    }
}
