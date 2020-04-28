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

    var previousFive = false
    var previousFiveVCNum:Int=0
    var previousFiveSelectedNum:Int=0
    var previousFiveNum1:Int=0
    var previousFiveNum2:Int=0
    
    var previousP2Five = false
    var previousP2FiveVCNum:Int=0
    var previousP2FiveSelectedNum:Int=0
    var previousP2FiveNum1:Int=0
    var previousP2FiveNum2:Int=0
    
    var previousSix = false
    var previousSixVCNum:Int=0
    var previousSixSelectedNum:Int=0
    var previousSixNum1:Int=0
    var previousSixNum2:Int=0
    
    var previousSeven = false
    var previousSevenVCNum:Int=0
    var previousSevenSelectedNum:Int=0
    var previousSevenNum1:Int=0
    var previousSevenNum2:Int=0
    
    var previousP2Seven = false
    var previousP2SevenVCNum:Int=0
    var previousP2SevenSelectedNum:Int=0
    var previousP2SevenNum1:Int=0
    var previousP2SevenNum2:Int=0
    
    var previousEight = false
    var previousEightVCNum:Int=0
    var previousEightSelectedNum:Int=0
    var previousEightNum1:Int=0
    var previousEightNum2:Int=0
    
    @IBOutlet weak var tryAgain: UILabel!
    @IBOutlet weak var tryagainhint: UILabel!
    @IBOutlet weak var restartBtn: UIButton!
    
    
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
            UIAccessibility.post(notification: .screenChanged, argument: tryAgain);
            let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: {timer in
                UIAccessibility.post(notification: .screenChanged, argument: self.tryagainhint)
            })
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
            
        // If the user is playing level five
        // no hint will be provided
        else if (previousFive == true) {
            tryagainhint.text = ""
            self.showAnimate()
        }
        
        // If the user is playing level fivept2
        // no hint will be provided
            
        else if (previousP2Five == true) {
            tryagainhint.text = ""
            self.showAnimate()
        }
        
        // If the user is playing level six
        // no hint will be provided
        else if (previousSix == true) {
            tryagainhint.text = "You were on number \(previousSixSelectedNum)"
            self.showAnimate()
        }
        else if (previousSeven == true) {
            tryagainhint.text = ""
            self.showAnimate()
        }
        
        // If the user is playing level fivept2
        // no hint will be provided
            
        else if (previousP2Seven == true) {
            tryagainhint.text = ""
            self.showAnimate()
        }
        else if (previousEight == true) {
            tryagainhint.text = "You were on number \(previousEightSelectedNum)"
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
        else if (previousFive == true) {
            let levelVC:LevelFiveGame=segue.destination as! LevelFiveGame
            levelVC.desiredNumber=previousFiveVCNum
            levelVC.num1=previousFiveNum1
            levelVC.num2=previousFiveNum2
        }
        else if (previousP2Five == true) {
            let levelVC:LevelFiveGamePt2=segue.destination as! LevelFiveGamePt2
            levelVC.desiredNumber=previousP2FiveVCNum
            levelVC.num1=previousP2FiveNum1
            levelVC.num2=previousP2FiveNum2
        }
        else if (previousSix == true) {
            let levelVC:LevelSixGame=segue.destination as! LevelSixGame
            levelVC.desiredNumber=previousSixVCNum
            levelVC.num1=previousSixNum1
            levelVC.num2=previousSixNum2
        }
        else if (previousSeven == true) {
            let levelVC:LevelSevenGame=segue.destination as! LevelSevenGame
            levelVC.desiredNumber=previousSevenVCNum
            levelVC.num1=previousSevenNum1
            levelVC.num2=previousSevenNum2
        }
        else if (previousP2Seven == true) {
            let levelVC:LevelSevenGamePt2=segue.destination as! LevelSevenGamePt2
            levelVC.desiredNumber=previousP2SevenVCNum
            levelVC.num1=previousP2SevenNum1
            levelVC.num2=previousP2SevenNum2
        }
        else if (previousEight == true) {
            let levelVC:LevelEightGame=segue.destination as! LevelEightGame
            levelVC.desiredNumber=previousEightVCNum
            levelVC.num1=previousEightNum1
            levelVC.num2=previousEightNum2
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
        if (previousFive == true) {
            performSegue(withIdentifier: "tryAgainToLevelFive", sender: self)
        }
        if (previousP2Five == true) {
            performSegue(withIdentifier: "tryAgainToLevelFiveP2", sender: self)
        }
        if (previousSix == true) {
            performSegue(withIdentifier: "tryAgainToLevelSix", sender: self)
        }
        if (previousSeven == true) {
            performSegue(withIdentifier: "tryAgainToLevelSeven", sender: self)
        }
        if (previousP2Seven == true) {
            performSegue(withIdentifier: "tryAgainToLevelSevenP2", sender: self)
        }
        if (previousEight == true) {
            performSegue(withIdentifier: "tryAgainToLevelEight", sender: self)
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
