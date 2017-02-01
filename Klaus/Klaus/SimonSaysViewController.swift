//
//  ViewController.swift
//  SimonSays
//
//  Created by Verena Schlott on 05.01.17.
//  Copyright (c) 2017 Verena Schlott. All rights reserved.
//
// To Do:
// - UI verschönern
//

import UIKit

class SimonSaysViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var commentator: UILabel!
    
    let gameID = 1
    let simonSaysModel: SimonSaysModel = SimonSaysModel()
    let stopWatchTimer: StopwatchTimer = StopwatchTimer(needGameUpdate: false, maxDuration: 0)
    
    override func viewDidLoad() {
        allowUserInteraction(possible: false)
        self.navigationItem.setHidesBackButton(true, animated: false)
        super.viewDidLoad()
        self.animateCurrentCode() // Starts game
    }
    
    // Animates next digit of code to the user
    func animateCurrentCode() {
        allowUserInteraction(possible: false)
        stopWatchTimer.stopTimer()
        
        changeLabel(label: display, newText: "")
        changeLabel(label: commentator, newText: Strings.simonSaysComputersTurnText)
        //changeColor(uiElement: display, color: "black")
        display.textColor = UIColor.black
        
        if simonSaysModel.computersTurn() {
            let digit = simonSaysModel.code.last
            delay(delay: 0.5){
                self.changeLabel(label: self.display, newText: digit!)
                self.simulateButtonPress(digit: digit!)
            }
            
            print("\nYour turn \(simonSaysModel.code)")
            
            delay(delay: 1.5){
                self.changeLabel(label: self.display, newText: "")
                self.allowUserInteraction(possible: true);
                //self.changeColor(uiElement: self.display, color: "blue");
                self.stopWatchTimer.startTimer()
            }
            
        } else {
            gameFinished(gameWon: true)
        }
    }
    
    // Handles user interaction & computes user input
    @IBAction func touchDigit(_ sender: UIButton) {
        changeLabel(label: commentator, newText: Strings.simonSaysPlayersTurnText)
        let button = sender.currentTitle!
        let digitsCurrentlyDisplayed = display!.text!
        changeLabel(label: display, newText: digitsCurrentlyDisplayed + button)
        
        switch simonSaysModel.playersTurn(playerInput: button) {
        case "wrong": display.textColor = UIColor.red
            allowUserInteraction(possible: false); gameFinished(gameWon: false);
        case "right": display.textColor = UIColor(red: 0.1725, green: 0.4784, blue: 0, alpha: 1.0)
            allowUserInteraction(possible: false); delay(delay: 1.5) {self.animateCurrentCode()};
        case "not finished": break
        default: break
        }
    }
    
    func gameFinished(gameWon: Bool) {
        stopWatchTimer.stopTimer()
        print ("\nStopwatch: \(stopWatchTimer.duration)")
        
        if gameWon {
            changeLabel(label: commentator, newText: Strings.simonSaysSuccessText)
        } else {
            changeLabel(label: self.commentator, newText: Strings.simonSaysLostText)
        }
        delay (delay: 1.5) { self.startResultViewController()}
    }
    
    func startResultViewController() {
        let vc = ResultViewController(result: Double(simonSaysModel.score), gameID: gameID)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func simulateButtonPress(digit: String) {
        var tag = 0
        if digit == "*" {
            tag = 10
        } else if digit == "#" {
            tag = 11
        } else  if digit == "0" {
            tag = 12
        } else {
            tag = Int(digit)!
        }
        let button = self.view.viewWithTag(tag) as? UIButton
        button?.isHighlighted = true
        delay(delay: 1.0) {button?.isHighlighted = false}
    }
    
    func changeLabel(label: UILabel, newText: String) {
        label.text = newText
    }
    
    func allowUserInteraction(possible: Bool) {
        self.view.isUserInteractionEnabled = possible
    }
    
    // Changes the color of an ui element
    func changeColor(uiElement: UIView, color: String) {
        switch color {
        case "red": uiElement.backgroundColor = UIColor.red
        case "blue": uiElement.backgroundColor = UIColor.blue
        case "green": uiElement.backgroundColor = UIColor.green
        case "black": uiElement.backgroundColor = UIColor.black
        case "grey": uiElement.backgroundColor = UIColor.lightGray
        default: break
        }
    }
    
    func delay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { closure()}
    }
    
}


