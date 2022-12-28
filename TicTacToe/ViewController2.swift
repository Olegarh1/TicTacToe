//
//  ViewController2.swift
//  TicTacToe
//
//  Created by Олег Закладний on 21.11.2022.
//

import UIKit
import FirebaseFirestore

class ViewController2: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var invalidUsenameLabel: UILabel!
    @IBOutlet weak var player1TextField: UITextField!
    @IBOutlet weak var player2TextField: UITextField!
    @IBOutlet var playButton: UIButton!
        
    let database = Firestore.firestore()
    let disallowedChars = [ " "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player1TextField.delegate = self
        player2TextField.delegate = self

        playButton.layer.cornerRadius = 25
    }
    
    @IBAction func tap(_ sender: Any)
    {
        player1TextField.resignFirstResponder()
        player2TextField.resignFirstResponder()
    }
    
    //Save data for players usernames
    func saveDataForPlayer1(text: String) {
        let docRef = database.document("TicTacToe/player1")
        docRef.setData(["text": text])
    }
    
    func saveDataForPlayer2(text: String) {
        let docRef = database.document("TicTacToe/player2")
        docRef.setData(["text": text])
    }
    
    @IBAction func playButton(_ sender: Any) {
        
        if let text = player1TextField.text, !text.isEmpty {
            saveDataForPlayer1(text: text)
        }
        if let text = player2TextField.text, !text.isEmpty {
            saveDataForPlayer2(text: text)
        }
        saveScoreForCross(text: "0")
        saveScoreForNoughts(text: "0")
    }
    
    func saveScoreForCross(text: String) {
        let docRef = database.document("TicTacToe/Cross")
        docRef.setData(["text": text])
    }
    
    func saveScoreForNoughts(text: String) {
        let docRef = database.document("TicTacToe/Noughts")
        docRef.setData(["text": text])
    }
}
