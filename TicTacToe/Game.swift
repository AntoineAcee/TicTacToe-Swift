//
//  Game.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 08/07/2019.
//  Copyright © 2019 Punchh Inc. All rights reserved.
//

import Foundation
import Firebase

enum GameStatus : String {
    case idle = "idle"
    case playing = "playing"
    case finished = "finished"
}

protocol GameDelegate {
    func didUpdate()
    func didClose()
}

class Game {
    var id : String?
    var gameValues: [[GameValue]]
    var players: [Player]
    var playerTurn: Player?
    var mode: GameMode
    var status: GameStatus
    var winner: Player? {
        didSet {
            self.status = self.winner == nil ? .playing : .finished
        }
    }
    var delegate: GameDelegate?
    
    private let winningBoards = [
        // HORIZONTAL
        [[1,1,1],[0,0,0],[0,0,0]],
        [[0,0,0],[1,1,1],[0,0,0]],
        [[0,0,0],[0,0,0],[1,1,1]],
        
        // VERTICAL
        [[1,0,0],[1,0,0], [1,0,0]],
        [[0,1,0],[0,1,0], [0,1,0]],
        [[0,0,1],[0,0,1], [0,0,1]],
        
        // DIAGONAL
        [[1,0,0],[0,1,0], [0,0,1]],
        [[0,0,1],[0,1,0], [1,0,0]],
    ]
    
    init(players: [Player], mode: GameMode) {
        self.players = players
        self.playerTurn = players.first
        self.mode = mode
        self.status = players.count == 2 ? .playing : .idle
        self.gameValues = [[.nothing, .nothing, .nothing],
                           [.nothing, .nothing, .nothing],
                           [.nothing, .nothing, .nothing]]
    }
    
    init(json : [String:Any], id : String?){
        self.id = id
        let jsonGameValues = json["gameValues"] as? [String] ?? [" ", " ", " ", " ", " ", " ", " ", " ", " "]
        
        var oneDimGameValues : [GameValue] = []
        for i in 0..<jsonGameValues.count{
            switch jsonGameValues[i] {
            case " ":
                oneDimGameValues.append(.nothing)
                break
            case "1":
                oneDimGameValues.append(.player1)
                break
            case "2":
                oneDimGameValues.append(.player2)
                break
            default :
                break
            }
        }
        
        var newGameValues : [[GameValue]] = []
        newGameValues.append(Array(oneDimGameValues[0...2]))
        newGameValues.append(Array(oneDimGameValues[3...5]))
        newGameValues.append(Array(oneDimGameValues[6...8]))
        self.gameValues = newGameValues
        
        let jsonPlayers = json["players"] as? [[String:Any]] ?? []
        self.players = jsonPlayers.map({ Player(json: $0) })
        
        for player in players {
            if player.id == (json["playerTurn"] as? String ?? "1") {
                self.playerTurn = player
            }
        }
        self.mode = .online
        self.status = GameStatus(rawValue: json["status"] as? String ?? "") ?? .idle
        self.winner = checkWinner()
    }
    
    func initGame(){
        if self.mode == .online {
            self.listenOnlineGame()
        }
        self.delegate?.didUpdate()
    }
    
    func play(row: Int, col: Int) {
        guard self.gameValues[row][col] == .nothing && self.status != .finished else { return }
        if self.mode == .online && playerTurn?.id != UserManager.shared.user?.id { return }
        
        self.gameValues[row][col] = playerTurn?.gameValue ?? .nothing
        self.playerTurn = players.first(where: {$0.id != self.playerTurn?.id})
        self.winner = checkWinner()
        if checkEndGame() {
            self.status = .finished
        }
        sendPlayToFirebase()
        self.delegate?.didUpdate()
    }
    
    func reset() {
        self.gameValues = [[.nothing, .nothing, .nothing],
                           [.nothing, .nothing, .nothing],
                           [.nothing, .nothing, .nothing]]
        self.winner = nil
        self.status = .playing
        self.sendPlayToFirebase()
        self.delegate?.didUpdate()
    }
    
    func toJson() -> [String:Any] {
        var gameValuesStr : [String] = []
        for gameValues in self.gameValues{
            for gameValue in gameValues {
                switch gameValue {
                case .nothing:
                    gameValuesStr.append(" ")
                case .player1:
                    gameValuesStr.append("1")
                case .player2:
                    gameValuesStr.append("2")
                }
            }
        }
        
        var json : [String:Any] = [
            "gameValues" : gameValuesStr,
            "players" : players.map({ $0.toJson() }),
            "playerTurn" : (playerTurn?.id ?? players.first?.id ?? ""),
            "status" : status.rawValue,
            "nbPlayers" : players.count
        ]
        
        if let winner = self.winner { json["winner"] = winner.id }
        return json
    }
    
    func deleteGame(){
        guard let gameId = self.id else { return }
        Firestore.firestore().collection("games").document(gameId).delete()
    }
    
    private func sendPlayToFirebase(){
        guard let gameId = self.id else { return }
        Firestore.firestore().collection("games").document(gameId).updateData(self.toJson())
    }
    
    private func updateGame(newGame: Game){
        guard self.mode == .online else { return }
        let needUpdate = self.players.count == 1 && newGame.players.count == 2
        
        self.gameValues = newGame.gameValues
        self.players = newGame.players
        self.playerTurn = newGame.playerTurn
        self.winner = newGame.winner
        self.status = newGame.status
        
        if needUpdate { sendPlayToFirebase() }
    }
    
    private func listenOnlineGame(){
        guard let gameId = self.id else { return }
        Firestore.firestore().collection("games").document(gameId).addSnapshotListener { (snapshot, err) in
            guard let gameJson = snapshot?.data() else {
                self.delegate?.didClose()
                return
            }
            self.updateGame(newGame: Game(json: gameJson, id: snapshot?.documentID))
            self.delegate?.didUpdate()
        }
    }
    
    private func checkWinner() -> Player? {
        for winningBoard in winningBoards {
            let playersTuple = compareGameValues(winningBoard: winningBoard)
            if playersTuple.player1win == true {
                return getPlayer(gameValue: .player1)
            }
            if playersTuple.player2win == true {
                return getPlayer(gameValue: .player2)
            }
        }
        return nil
    }
    
    private func compareGameValues(winningBoard: [[Int]]) -> (player1win: Bool, player2win: Bool) {
        var filteredGameValues: [GameValue] = []
        for i in 0..<self.gameValues.count {
            for j in 0..<self.gameValues[i].count {
                if winningBoard[i][j] == 1 {
                    filteredGameValues.append(self.gameValues[i][j])
                }
            }
        }
        let player1win = filteredGameValues.allSatisfy({$0 == .player1})
        let player2win = filteredGameValues.allSatisfy({$0 == .player2})
        return (player1win, player2win)
    }
    
    private func getPlayer(gameValue: GameValue) -> Player? {
        return players.first(where: {$0.gameValue == gameValue})
    }
    
    private func checkEndGame() -> Bool {
        return self.gameValues.allSatisfy({ (gameValues) -> Bool in
            return gameValues.allSatisfy({$0 != .nothing})
        })
    }
}
