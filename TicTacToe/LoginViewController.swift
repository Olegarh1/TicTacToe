//
//  LoginViewController.swift
//  TicTacToe
//
//  Created by Олег Закладний on 21.11.2022.
//

import UIKit

class LoginViewController: UIViewController
{

    @IBOutlet var player1TextField: UITextField!
    @IBOutlet var player2TextField: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC: ViewController = segue.destination as! ViewController
        {
            destinationVC.player1 = player1TextField.text!
            destinationVC.player2 = player2TextField.text!
        }
    }
}
