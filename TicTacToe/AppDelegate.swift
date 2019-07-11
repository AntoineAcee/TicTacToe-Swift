//
//  AppDelegate.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 21/06/19.
//  Copyright © 2019 Antoine Lefevre All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        FirebaseApp.configure()
        
        if let currentUser = Auth.auth().currentUser {
            UserManager.shared.setUserInfo(userId: currentUser.uid) {}
        }
        
    }
}

