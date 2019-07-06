//
//  GameValueCell.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 06/07/2019.
//  Copyright © 2019 Punchh Inc. All rights reserved.
//

import UIKit

class GameValueCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    
    func setup(gameValue: GameValue) {
        switch gameValue {
        case .nothing:
            cellImage.image = nil
        case .player1:
            cellImage.image = UIImage(named: "taco")
        case .player2:
            cellImage.image = UIImage(named: "burger")
        }
    }
}
