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
    }
    @IBAction func playOnline(_ sender: Any) {
        if !self.checkConnection() { return }
        let onlineGame = Game(players: [OfflineManager.shared.player1, OfflineManager.shared.player2], mode: GameMode.online)
        self.present(GameViewController.instantiate(game: onlineGame), animated: true)
    }
    
    @IBAction func playOffline(_ sender: Any) {
        let offlineGame = Game(players: [OfflineManager.shared.player1, OfflineManager.shared.player2], mode: GameMode.offline)
        self.present(GameViewController.instantiate(game: offlineGame), animated: true)
    }
    
    func checkConnection() -> Bool {
        if OnlineManager.shared.player == nil {
            let signInViewController = SignInViewController.instantiate()
            self.present(signInViewController, animated: true)
            return false
        }
        return true
    }
}
