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
    
    let simonSaysModel: SimonSaysModel = SimonSaysModel()
    let stopWatchTimer: StopwatchTimer = StopwatchTimer()
    
    override func viewDidLoad() {
        allowUserInteraction(possible: false)
        super.viewDidLoad()
        self.animateCurrentCode() // Starts game
    }
    
    // Animates next digit of code to the user
    func animateCurrentCode() {
        allowUserInteraction(possible: false)
        stopWatchTimer.stopTimer()
        
        changeLabel(label: display, newText: "")
        changeLabel(label: commentator, newText: Strings.simonSaysComputersTurnText)
        changeColor(uiElement: display, color: "black")
        
        if simonSaysModel.computersTurn() {
            let digit = simonSaysModel.code.last
            delay(delay: 0.5){
                self.changeLabel(label: self.display, newText: digit!)
                self.simulateButtonPress(digit: digit!)
            }
            
            print("\nYour turn \(simonSaysModel.code)")
            
            delay(delay: 2.0){
                self.changeLabel(label: self.display, newText: "")
                self.allowUserInteraction(possible: true);
                self.changeColor(uiElement: self.display, color: "blue");
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
        case "wrong": changeColor(uiElement: display, color:"red"); allowUserInteraction(possible: false); gameFinished(gameWon: false);
        case "right": changeColor(uiElement: display, color:"green"); allowUserInteraction(possible: false); delay(delay: 1.0) {self.animateCurrentCode()};
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
        delay (delay: 1.0) { self.startResultViewController()}
    }
    
    func startResultViewController() {
        let vc = ResultViewController(result: Double(simonSaysModel.score))
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
        changeColor(uiElement: button!, color: "pink")
        delay(delay: 1.5) {self.changeColor(uiElement: button!, color: "grey")}
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
        case "pink": uiElement.backgroundColor = UIColor(red: 0.93, green: 0.44, blue: 0.86, alpha: 1.0)
        default: break
        }
    }
    
    func delay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { closure()}
    }
    
}


