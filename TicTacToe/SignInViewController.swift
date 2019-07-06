//
//  SignInViewController.swift
//  TicTacToe
//
//  Created by Antoine Lefevre on 06/07/2019.
//  Copyright © 2019 Punchh Inc. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    let db = Firestore.firestore()
    
    static func instantiate() -> SignInViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signIn(_ sender: Any) {
        hasUser(email: emailText.text) { (exist) in
            if exist {
                self.signIn()
            } else {
                self.signUp()
            }
        }
    }
    
    func signIn() {
        guard let email = emailText.text, let password = passwordText.text else { return }
        loader.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            self.loader.stopAnimating()
            if let err = error {
                self.showAlert(title: "Error", message: err.localizedDescription)
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
    func signUp() {
        guard let email = emailText.text, let password = passwordText.text else { return }
        loader.startAnimating()
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            self.loader.stopAnimating()
            if let err = error {
                self.showAlert(title: "Error", message: err.localizedDescription)
            } else {
                self.db.collection("users").addDocument(data: [
                    "email": email,
                    "wins": 0,
                    "looses": 0,
                    ])
                self.dismiss(animated: true)
            }
        }
    }
    
    func hasUser(email: String?, callback: @escaping (Bool) -> () ){
        guard let emailStr = email else {
            callback(false)
            return
        }
        
        db.collection("users").whereField("email", isEqualTo: emailStr).getDocuments { (snapshot, error) in
            callback((snapshot?.count ?? 0) > 0)
        }
    }
    

}
