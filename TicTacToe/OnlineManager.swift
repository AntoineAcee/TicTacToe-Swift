//
//  OnlineManager.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 09/07/2019.
//  Copyright © 2019 Punchh Inc. All rights reserved.
//

import Foundation
import Firebase

class OnlineManager {
    static let shared = OnlineManager()
    var player: Player?
    
    func setPlayerInfo(userId: String, callback: @escaping () -> ()) {
        Firestore.firestore().collection("users").document(userId).addSnapshotListener { (snapshot, error) in
            self.player = Player(snapshot: snapshot)
            callback()
        }
    }
}
