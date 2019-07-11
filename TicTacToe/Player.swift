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
    var ready : Bool = true
    
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
    
    init(json : [String:Any]){
        self.id = json["id"] as? String ?? "1"
        self.email = json["email"] as? String ?? "Player 1"
        self.ready = json["ready"] as? Bool ?? false
        self.wins = 0
        self.looses = 0
        self.gameValue = GameValue(rawValue: json["gameValue"] as? String ?? "") ?? .player1
    }
    
    func toJson() -> [String:Any] {
        return [
            "id" : id,
            "email" : email,
            "ready" : ready,
            "gameValue" : gameValue.rawValue,
        ]
    }
}
