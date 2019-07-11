//
//  OnlineManager.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 09/07/2019.
//  Copyright © 2019 Punchh Inc. All rights reserved.
//

import Foundation
import Firebase

protocol UserManagerDelegate {
    func didReceiveNewGame()
}

class UserManager {
    static let shared = UserManager()
    
    var user : Player?
    var delegate : UserManagerDelegate?
    var offlinePlayer1: Player
    var offlinePlayer2: Player
    
    init() {
        offlinePlayer1 = Player(id: "1", email: "player1", wins: 0, looses: 0, gameValue: .player1)
        offlinePlayer2 = Player(id: "2", email: "player2", wins: 0, looses: 0, gameValue: .player2)
    }
    
    func setUserInfo(userId: String, callback: @escaping () -> ()) {
        Firestore.firestore().collection("users").document(userId).addSnapshotListener { (snapshot, error) in
            self.user = Player(snapshot: snapshot)
            callback()
        }
    }
    
    func createOrJoinGame(callback : @escaping (Game) -> ()){
        Firestore.firestore().collection("games").whereField("nbPlayers", isLessThan: 2).getDocuments { (snapshot, error) in
            if let gameSnapshot = snapshot?.documents.first{
                self.joinGame(game: Game(json: gameSnapshot.data(), id: gameSnapshot.documentID), callback: { (newGame) in
                    callback(newGame)
                })
            }else{
                self.createGame(callback: { (newGame) in
                    callback(newGame)
                })
            }
        }
    }
    
    private func createGame(callback : @escaping (Game) -> ()){
        let game = Game(players: self.user != nil ? [self.user!] : [], mode: GameMode.online)
        var ref: DocumentReference?
        ref = Firestore.firestore().collection("games").addDocument(data: game.toJson()) { (error) in
            let newGame = game
            newGame.id = ref?.documentID
            callback(game)
        }
    }
    
    private func joinGame(game: Game, callback : @escaping (Game) -> ()){
        let newGame = game
        guard var newPlayer = self.user, let gameToJoinId = game.id else { return }
        Firestore.firestore().collection("games").document(gameToJoinId).updateData(["nbPlayers" : 2])
        
        newPlayer.gameValue = .player2
        newGame.players.append(newPlayer)
        Firestore.firestore().collection("games").document(gameToJoinId).updateData(["players" : newGame.players.map({  $0.toJson()})]) { (error) in
            callback(newGame)
        }
    }
}
