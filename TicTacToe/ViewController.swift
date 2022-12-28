//
//  ViewController.swift
//  TicTacToe
//
//  Created by Олег Закладний on 18.11.2022.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController
{
    enum Turn
    {
        case Nought
        case Cross
    }

    @IBOutlet var player1Label: UILabel!
    @IBOutlet var player2Label: UILabel!
    @IBOutlet var score1Label: UILabel!
    @IBOutlet var score2Label: UILabel!
    @IBOutlet var turnLabel: UILabel!
    @IBOutlet var a1: UIButton!
    @IBOutlet var a2: UIButton!
    @IBOutlet var a3: UIButton!
    @IBOutlet var b1: UIButton!
    @IBOutlet var b2: UIButton!
    @IBOutlet var b3: UIButton!
    @IBOutlet var c1: UIButton!
    @IBOutlet var c2: UIButton!
    @IBOutlet var c3: UIButton!
    
    var firstTurn =  Turn.Cross
    var currentTurn = Turn.Cross
     
    var NOUGHT = "O"
    var CROSS = "X"
    var board = [UIButton]()
    
    var noughtsScore: Int = 0
    var crossesScore: Int = 0
    
    var player1: String = "" //CROSS
    var player2: String = "" //NOUGHT
    let database: Firestore = Firestore.firestore()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initBoard()
        //Firebase for player 1
        var docRef = database.document("TicTacToe/player1")
        docRef.addSnapshotListener{ [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            guard let text = data["text"] as? String else{
                return
            }
            
            DispatchQueue.main.async {
                self?.player1Label.text = "\(text): "
                self?.turnLabel.text = text
                self?.player1 = text
            }
        }
        //Firebase for player 2
        docRef = database.document("TicTacToe/player2")
        docRef.addSnapshotListener{ [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            guard let text = data["text"] as? String else{
                return
            }
            
            DispatchQueue.main.async {
                self?.player2Label.text = "\(text): "
                self?.turnLabel.text = text
                self?.player2 = text
            }
        }
        //Firebase for noughts score
        docRef = database.document("TicTacToe/Noughts")
        docRef.addSnapshotListener{ [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            guard let text = data["text"] as? String else{
                return
            }
            
            DispatchQueue.main.async {
                self?.noughtsScore = Int(text) ?? 0
                self?.score2Label.text = String(text)
            }
        }
        //Firebase for crosses score
        docRef = database.document("TicTacToe/Cross")
        docRef.addSnapshotListener{ [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            guard let text = data["text"] as? String else{
                return
            }
            
            DispatchQueue.main.async {
                self?.crossesScore = Int(text) ?? 0
                self?.score1Label.text = String(text)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func initBoard()
    {
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }

    @IBAction func boardTapAction(_ sender: UIButton)
    {
        addToBoard(sender)
        if checkForVictory(CROSS)
        {
            crossesScore += 1
            score1Label.text = "\(crossesScore)"
            resultAlert(title: "\(player1) Win!")
        }
        if checkForVictory(NOUGHT)
        {
            noughtsScore += 1
            score2Label.text = "\(noughtsScore)"
            resultAlert(title: "\(player2) Win!")
        }
        
        if (fullBoard())
        {
            resultAlert(title: "Draw")
        }
    }
    
    func checkForVictory(_ s: String) -> Bool
    {
        // Horizontal victory
        if thisSymbol(a1, s) && thisSymbol(a2, s) && thisSymbol(a3, s)
        {
            return true
        }
        if thisSymbol(b1, s) && thisSymbol(b2, s) && thisSymbol(b3, s)
        {
            return true
        }
        if thisSymbol(c1, s) && thisSymbol(c2, s) && thisSymbol(c3, s)
        {
            return true
        }
        
        // Vertical victory
        if thisSymbol(a1, s) && thisSymbol(b1, s) && thisSymbol(c1, s)
        {
            return true
        }
        if thisSymbol(a2, s) && thisSymbol(b2, s) && thisSymbol(c2, s)
        {
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b3, s) && thisSymbol(c3, s)
        {
            return true
        }
        
        // Diagonal victory
        if thisSymbol(a1, s) && thisSymbol(b2, s) && thisSymbol(c3, s)
        {
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b2, s) && thisSymbol(c1, s)
        {
            return true
        }
        return false
    }
    
    func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool
    {
        return button.title(for: .normal) == symbol
    }
    
    func resultAlert(title: String)
    {
        let score = "\n\(player1): \(crossesScore) \n\n\(player2): \(noughtsScore)"
        let message = UIAlertController(title: title, message: score, preferredStyle: .actionSheet)
        message.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            self.resetBoard()
        }))
        self.present(message, animated: true)
        
        saveScoreForCross(text: String(crossesScore))
        saveScoreForNoughts(text: String(noughtsScore))
    }
    
    func resetBoard()
    {
        for button in board
        {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        if(firstTurn == Turn.Nought)
        {
            firstTurn = Turn.Cross
            turnLabel.text = player1
        }
        else if(firstTurn == Turn.Cross)
        {
            firstTurn = Turn.Nought
            turnLabel.text = player2
        }
        currentTurn = firstTurn
    }
    
    func fullBoard() -> Bool
    {
        for button in board
        {
            if button.title(for: .normal) == nil
            {
                return false
            }
        }
        return true
    }
    
    func addToBoard(_ sender: UIButton)
    {
        if(sender.title(for: .normal) == nil)
        {
            if(currentTurn == Turn.Nought)
            {
                sender.setTitle(NOUGHT, for: .normal)
                currentTurn = Turn.Cross
                turnLabel.text = player1
            }
            else if(currentTurn == Turn.Cross)
            {
                sender.setTitle(CROSS, for: .normal)
                currentTurn = Turn.Nought
                turnLabel.text = player2
            }
            sender.isEnabled = false
        }
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

