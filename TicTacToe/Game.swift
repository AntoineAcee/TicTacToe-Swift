//
//  Game.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 08/07/2019.
//  Copyright © 2019 Punchh Inc. All rights reserved.
//

import Foundation

enum GameStatus {
    case idle
    case playing
    case finished
}

protocol GameDelegate {
    func didUpdate()
}

class Game {
    var gameValues: [[GameValue]]
    var players: [Player]
    var playerTurn: Player?
    var mode: GameMode
    var status: GameStatus = .idle
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
        self.gameValues = [[.nothing, .nothing, .nothing],
                           [.nothing, .nothing, .nothing],
                           [.nothing, .nothing, .nothing]]
    }
    
    func play(row: Int, col: Int) {
        guard self.gameValues[row][col] == .nothing && self.status != .finished else { return }
        
        self.gameValues[row][col] = playerTurn?.gameValue ?? .nothing
        self.playerTurn = players.first(where: {$0.id != self.playerTurn?.id})
        self.winner = checkWinner()
        if checkEndGame() {
            self.status = .finished
        }
        self.delegate?.didUpdate()
    }
    
    func reset() {
        self.gameValues = [[.nothing, .nothing, .nothing],
                          [.nothing, .nothing, .nothing],
                          [.nothing, .nothing, .nothing]]
        self.winner = nil
        self.status = .idle
        self.delegate?.didUpdate()
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
