//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 06/07/2019.
//  Copyright © 2019 Punchh Inc. All rights reserved.
//

import UIKit

enum GameMode {
    case online
    case offline
}

enum GameValue {
    case nothing
    case player1
    case player2
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameCollectionView: UICollectionView!
    
    var gameMode: GameMode!
    var gameValues: [[GameValue]] = [
        [.player1, .player2, .nothing],
        [.nothing, .nothing, .nothing],
        [.nothing, .nothing, .nothing]
    ]
    
    static func instantiate(gameMode: GameMode) -> GameViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let gameController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        gameController.gameMode = gameMode
        return gameController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameCollectionView.delegate = self
        gameCollectionView.dataSource = self
        
        gameCollectionView.reloadData()
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gameValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameValues[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:GameValueCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameValueCell", for: indexPath) as! GameValueCell
        cell.setup(gameValue: gameValues[indexPath.section][indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gameValues[indexPath.section][indexPath.row] = .player1
        collectionView.reloadData()
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
}
