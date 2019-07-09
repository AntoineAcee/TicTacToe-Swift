//
//  Player.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 08/07/2019.
//  Copyright © 2019 Punchh Inc. All rights reserved.
//

import Foundation
import Firebase

struct Player {
    var id: String
    var email: String
    var wins: Int
    var looses: Int
    var gameValue: GameValue
    
    init(snapshot: DocumentSnapshot?) {
        self.id = snapshot?.documentID ?? "1"
        self.email = snapshot?.data()?["email"] as? String ?? "Player 1"
        self.looses = snapshot?.data()?["looses"] as? Int ?? 0
        self.wins = snapshot?.data()?["wins"] as? Int ?? 0
        self.gameValue = .player1
    }
    
    init(id: String, email: String, wins: Int, looses: Int, gameValue: GameValue) {
        self.id = id
        self.email = email
        self.wins = wins
        self.looses = looses
        self.gameValue = gameValue
    }
}
