//
//  IncorrectPopUpViewController.swift
//  Number Line
//
//  Created by Tian Liu on 4/2/19.
//  Copyright © 2019 Tian Liu. All rights reserved.
//

import UIKit

class IncorrectPopUpViewController: UIViewController {
    
    var previousOne = false
    var previousOneVCNum:Int=0
    var previousOneSelectedNum:Int=0
    var previousGreater = false
    var previousSmaller = false
    
    var previousTwo = false
    var previousTwoVCNum:Int=0
    var previousTwoSelectedNum:Int=0
    var previousTwoOnNumberLine = false
    
    var previousThree = false
    var previousThreeDesiredNum:Int=0
    var previousThreeAstronautNum:Int=0
    
    var previousFour = false
    var previousFourDesiredNum:Int=0
    var previousFourAstronautNum:Int=0
    

    @IBOutlet weak var tryagainhint: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If the user is playing level one
        // tell the user that the correct answer is greater/smaller than the selected answer
        if (previousOne == true) {
            if (previousGreater == true) {
                tryagainhint.text = "The correct answer is greater than your answer"
            }
            else {
                tryagainhint.text = "The correct answer is less than your answer"
            }
            self.showAnimate()
        }
        
        // If the user is playing level two
        // tell the user that either he/she wasn't on the line or that he/she chose a wrong answer
        else if (previousTwo == true) {
            if (previousTwoOnNumberLine == true) {
                tryagainhint.text = "You were not on the number line"
            }
            else {
                tryagainhint.text = "You were on number \(previousTwoSelectedNum)"
            }
            self.showAnimate()
        }
        
        // If the user is playing level three
        // no hint will be provided
        else if (previousThree == true) {
            tryagainhint.text = ""
            self.showAnimate()
        }
        
        // If the user is playing level four
        // no hint will be provided
        else if (previousFour == true) {
            tryagainhint.text = ""
            self.showAnimate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Direct the player back to the same round so the player can retry the game
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (previousOne == true) {
            let levelVC:LevelOneGame=segue.destination as! LevelOneGame
            levelVC.desiredNumber=previousOneVCNum
        }

        else if (previousTwo == true) {
            let levelVC:LevelTwoGame=segue.destination as! LevelTwoGame
            levelVC.desiredNumber=previousTwoVCNum
        }
        
        else if (previousThree == true) {
            let levelVC:LevelThreeGame=segue.destination as! LevelThreeGame
            levelVC.desiredNumber=previousThreeDesiredNum
            levelVC.astronautNumber=previousThreeAstronautNum
        }
        
        else if (previousFour == true) {
            let levelVC:LevelFourGame=segue.destination as! LevelFourGame
            levelVC.desiredNumber=previousFourDesiredNum
            levelVC.astronautNumber=previousFourAstronautNum
        }
    }

    // Allows the player to go back to previous page
    @IBAction func restart(_ sender: Any) {
        if (previousOne == true) {
            performSegue(withIdentifier: "tryAgainToLevelOne", sender: self)
        }

        if (previousTwo == true) {
           performSegue(withIdentifier: "tryAgainToLevelTwo", sender: self)
        }
        
        if (previousThree == true) {
            performSegue(withIdentifier: "tryAgainToLevelThree", sender: self)
        }
        
        if (previousFour == true) {
            performSegue(withIdentifier: "tryAgainToLevelFour", sender: self)
        }
    }
    
    // Helper method - show the popup window animation
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }

    // Currently not used, may need for future reference
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
}
}
