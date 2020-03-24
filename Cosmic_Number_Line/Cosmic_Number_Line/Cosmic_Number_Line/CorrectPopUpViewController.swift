//
//  CorrectPopUpViewController.swift
//  Number Line
//
//  Created by Tian Liu on 4/2/19.
//  Copyright © 2019 Tian Liu. All rights reserved.
//

import UIKit

class CorrectPopUpViewController: UIViewController {
    var parentOneVC:LevelOneGame?=nil
    var parentTwoVC:LevelTwoGame?=nil
    var parentThreeVC:LevelThreeGame?=nil
    var parentFourVC:LevelFourGame?=nil
    var numLevelsComplete:Int=0
    
    // Directs the player to level selection page
//    @IBAction func closeButtonTouched(_ sender: Any) {
//        self.removeAnimate()
//        performSegue(withIdentifier: "ToLevelSelect", sender: self)
//    }
    
    // Directs the player to the next level
    @IBAction func nextLevel(_ sender: Any) {
        
        if((parentOneVC) != nil)
        {
            performSegue(withIdentifier: "backToLevelOne", sender: self)
            parentOneVC?.removePopOverView()
        }
        
        if((parentTwoVC) != nil)
        {
            performSegue(withIdentifier: "backToLevelTwo", sender: self)
            parentTwoVC?.removePopOverView()
        }
        
        if((parentThreeVC) != nil)
        {
            performSegue(withIdentifier: "backToLevelThree", sender: self)
            parentThreeVC?.removePopOverView()
        }
        
        if((parentFourVC) != nil)
        {
            performSegue(withIdentifier: "backToLevelFour", sender: self)
            parentFourVC?.removePopOverView()
        }
    }
    
    // Directs the player to the next level of game
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if((parentOneVC) != nil)
        {
            if let destinationVC = segue.destination as? LevelOneGame{
                destinationVC.howManyLevelsAreDone = self.numLevelsComplete + 1
                destinationVC.previousVC=self
            }
        }
        if((parentTwoVC) != nil)
        {
            if let destinationVC = segue.destination as? LevelTwoGame{
                destinationVC.howManyLevelsAreDone = self.numLevelsComplete + 1
                destinationVC.previousVC=self
            }
        }
        if((parentThreeVC) != nil)
        {
            if let destinationVC = segue.destination as? LevelThreeGame{
                destinationVC.howManyLevelsAreDone = self.numLevelsComplete + 1
                destinationVC.previousVC=self
            }
        }
        if((parentFourVC) != nil)
        {
            if let destinationVC = segue.destination as? LevelFourGame{
                destinationVC.howManyLevelsAreDone = self.numLevelsComplete + 1
                destinationVC.previousVC=self
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // popup window animation
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // remoeve popup window animation
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
