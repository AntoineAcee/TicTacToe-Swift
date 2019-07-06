//
//  UsefullExtensions.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 06/07/2019.
//  Copyright © 2019 Punchh Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title : String, message : String, actions : [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel) { (_) in }], style : UIAlertController.Style = .actionSheet){
        
        var alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        if UIDevice().model == "iPad" {
            alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        }
        
        for action in actions{
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
