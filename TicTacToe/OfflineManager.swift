//
//  OfflineManager.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 08/07/2019.
//  Copyright © 2019 Punchh Inc. All rights reserved.
//

import Foundation

class OfflineManager {
    static let shared = OfflineManager()
    var player1: Player
    var player2: Player
    
    init() {
        player1 = Player(id: "1", email: "player1", wins: 0, looses: 0, gameValue: .player1)
        player2 = Player(id: "2", email: "player2", wins: 0, looses: 0, gameValue: .player2)
    }
}
