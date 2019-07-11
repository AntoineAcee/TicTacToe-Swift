//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 06/07/2019.
//  Copyright © 2019 Punchh Inc. All rights reserved.
//

import UIKit

enum GameMode : String {
    case online = "online"
    case offline = "offline"
}

enum GameValue : String {
    case nothing = " "
    case player1 = "1"
    case player2 = "2"
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var gameInfoLabel: UILabel!
    @IBOutlet weak var waitLabel: UILabel!
    
    var game: Game!
    
    static func instantiate(game: Game) -> GameViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let gameController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        gameController.game = game
        return gameController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGame()
        gameCollectionView.delegate = self
        gameCollectionView.dataSource = self
        
        gameCollectionView.reloadData()
    }
    
    func initGame() {
        game.delegate = self
        game.initGame()
    }
    
    func setWaitLabel() {
        self.waitLabel.isHidden = self.game.players.count >= 2
    }
    
    @IBAction func onReset(_ sender: Any) {
        self.game.reset()
        self.gameCollectionView.reloadData()
    }
    
    @IBAction func onClose(_ sender: Any) {
        game.deleteGame()
        self.dismiss(animated: true)
    }
    
    func setGameInfo() {
        self.gameInfoLabel.text = "\(game.playerTurn?.email ?? "") turn"
        if game.status == .finished {
            if let winner = game.winner {
                self.gameInfoLabel.text = "\(winner.email) win"
            } else {
                self.gameInfoLabel.text = "Draw"
            }
        }
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return game.gameValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.gameValues[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:GameValueCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameValueCell", for: indexPath) as! GameValueCell
        cell.setup(gameValue: game.gameValues[indexPath.section][indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        game.play(row: indexPath.section, col: indexPath.row)
        collectionView.reloadData()
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension GameViewController: GameDelegate {
    func didUpdate() {
        self.gameCollectionView.reloadData()
        self.setGameInfo()
        self.setWaitLabel()
    }
    
    func didClose() {
        let closeAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true)
        }
        self.showAlert(title: "The opponent has left the game", message: "Your game will be closed too", actions: [closeAction])
    }
}
