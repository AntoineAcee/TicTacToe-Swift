//
//  OnlineManager.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 09/07/2019.
//  Copyright © 2019 Punchh Inc. All rights reserved.
//

import Foundation
import Firebase

protocol OnlineManagerDelegate {
    func didUpdate()
}

class OnlineManager {
    static let shared = OnlineManager()
    var player1: Player?
    var player2: Player?
    var delegate: OnlineManagerDelegate?
    
    func setPlayerInfo(userId: String, callback: @escaping () -> ()) {
        Firestore.firestore().collection("users").document(userId).addSnapshotListener { (snapshot, error) in
            self.player1 = Player(snapshot: snapshot)
            callback()
        }
    }
}
