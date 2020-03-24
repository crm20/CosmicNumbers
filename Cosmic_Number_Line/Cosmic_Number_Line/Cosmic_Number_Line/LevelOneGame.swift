//
//  LevelOneGameViewController.swift
//  Cosmic_Number_Line
//
//  Created by hyunc on 3/21/20.
//  Copyright © 2020 Cosmic_Numbers. All rights reserved.
//

import UIKit
import AVFoundation

class LevelOneGame: UIViewController {
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var lineRef: Line!
    @IBOutlet weak var astronaut: UIImageView!
    @IBOutlet weak var zero: UIButton!
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var tutorial: UIButton!
    @IBOutlet weak var levels: UIButton!
    
    var desiredNumber=Int.random(in: 0...5)
    var player: AVAudioPlayer?
    var accessibleNumbers:[UIView]=[]
    var selectedAnswer = 0
    var howManyLevelsAreDone:Int=0
    var previousVC:UIViewController?=nil
    var answerArray: [UIButton]=[]
    var answerSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // save answer buttons into an array
        answerArray = [zero, one, two, three, four, five]
        
        // Make the screen accessible, and specify the question with a randomly chosen number from 0-5
        isAccessibilityElement = true
        
        let linerefbounds:CGRect=lineRef.bounds
        
        // begin changes
        //let minXOfLine = lineRef.center.x-(linerefbounds.width/2) - 40
        
        let minXOfLine = lineRef.center.x-(linerefbounds.width/2)
        let distance = linerefbounds.width/(linerefbounds.width/163.2)
        let xdist = (distance*CGFloat(desiredNumber))
        let finalx = xdist+lineRef.offSetFromEdges + minXOfLine - astronaut.frame.size.width/3
        /*
        print("Details")
        print(minXOfLine)
        print(lineRef.distance)
        print(linerefbounds.width)
        print(xdist)
        print(lineRef.offSetFromEdges)
        print(finalx)
        print(linerefbounds.width)
        print(selectedAnswer)
        print(desiredNumber)
        astronaut.frame = CGRect(x: minXOfLine + ((linerefbounds.width) / 5 * CGFloat(desiredNumber)),  y: lineRef.center.y, width: astronaut.frame.size.width, height: astronaut.frame.size.height)
        */
        astronaut.frame = CGRect(x: finalx,  y: lineRef.center.y, width: astronaut.frame.size.width, height: astronaut.frame.size.height)
        // end changes
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        for answer in answerArray {
            if (answer == button) {
                answerSelected = true
                button.backgroundColor = UIColor(red:0.43, green:0.17, blue:0.56, alpha:1.0)
                button.setTitleColor(UIColor.white, for: .normal)
                button.accessibilityValue = "Selected"
                if let text = button.titleLabel?.text {
                    selectedAnswer = Int(text) ?? 0
                }
            }
            else {
                answerSelected = false
                answer.backgroundColor = UIColor(red:0.90, green:0.73, blue:0.17, alpha:1.0)
                answer.setTitleColor(UIColor.black, for: .normal)
                answer.accessibilityValue = ""
            }
        }
    }
    // Create number labels for the number line
    func initializeNumberTexts(){
        print("YCU")
        print(lineRef.distance)
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let distance = lineRef.distance
        let textHeight=100
        let textWidth=40
        var linerefbounds:CGRect=lineRef.bounds
        let spaceBetweenLineAndText:CGFloat=10.0
        var i = 0
        
        // Create 5 labels and make them accessible
        while (i < lineRef.numberOfPoints+1) {
            let xdist = (distance*CGFloat(i))
            var minXOfLine = lineRef.center.x-(linerefbounds.width/2)
            var maxYOfLine = lineRef.center.y+(linerefbounds.height/2)
            let label = UILabel(frame: CGRect(x: xdist+lineRef.offSetFromEdges + minXOfLine, y: maxYOfLine+spaceBetweenLineAndText, width: CGFloat(textWidth), height: CGFloat(textHeight)))
            /*
            print("start")
            print(lineRef.distance)
            print("end")
             */
            label.isAccessibilityElement = true
            label.text = String(i)
            label.font = UIFont(name: "Arial-BoldMT", size: 50)
            label.textColor = UIColor.white;
            self.view.addSubview(label)
            label.accessibilityTraits = UIAccessibilityTraits.playsSound
            label.isUserInteractionEnabled = true
            label.accessibilityLabel = String(i)
            accessibleNumbers.append(label)
            i = i+1
        }
        self.view.accessibilityElements = [question, lineRef, astronaut, accessibleNumbers, zero, one, two, three, four, five, submitBtn, tutorial, levels];
    }
    
    
    @IBAction func Submit(_ sender: Any) {
        if  (selectedAnswer == desiredNumber) {
            performSegue(withIdentifier: "toCongrats", sender: self)
        }
        else {
            performSegue(withIdentifier: "toTryAgain", sender: self)
        }
    }
    
    // May need for future reference
    func removePopOverView(){
    }
    
    // Based on whether the player answered the question correctly, this function will direct the player to either incorrect/correct popup window
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var tryAgainVC=segue.destination as? IncorrectPopUpViewController
        
        //If the player answered the question incorrectly, he/she needs to try the same round again
        if(tryAgainVC != nil){
            tryAgainVC?.previousOneVCNum=desiredNumber
            tryAgainVC?.previousOneSelectedNum=selectedAnswer
            tryAgainVC?.previousOne=true
            if (desiredNumber > selectedAnswer) {
                tryAgainVC?.previousGreater = true
            }
            else {
                tryAgainVC?.previousSmaller = true
            }
        }
        else{
            // If the player answered the question correctly, he/she will play the next round
            var rightVC = segue.destination as? CorrectPopUpViewController
            if (rightVC != nil){
                rightVC!.parentOneVC=self
                rightVC!.numLevelsComplete=self.howManyLevelsAreDone
            }
            else{
                print("other vc")
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
