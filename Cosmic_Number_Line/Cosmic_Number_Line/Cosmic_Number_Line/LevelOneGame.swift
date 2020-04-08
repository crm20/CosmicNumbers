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
    
    var desiredNumber = Int.random(in: 0...5)
    var player: AVAudioPlayer?
    var accessibleNumbers:[UIView] = []
    var selectedAnswer = 0
    var howManyLevelsAreDone:Int=0
    var previousVC:UIViewController? = nil
    var answerArray: [UIButton] = []
    var answerSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Saving the answer buttons into an array
        answerArray = [zero, one, two, three, four, five]
        
        // Make the screen accessible, and specify the question with a randomly chosen number from 0-5
        isAccessibilityElement = true
    }
    
    // Function that is called when the player selects an answer choice.
    @IBAction func buttonPressed(_ sender: Any) {
        // Safety catch.
        guard let button = sender as? UIButton else {
            return
        }
        
        // Goes through the [answerArray] to find the button that was clicked.
        for answer in answerArray {
            // If true, change the button's background color to dark purple, its text to white, and its accessibility value.
            if (answer == button) {
                answerSelected = true
                button.backgroundColor = UIColor(red:0.43, green:0.17, blue:0.56, alpha:1.0)
                button.setTitleColor(UIColor.white, for: .normal)
                button.accessibilityValue = "Selected"
                if let text = button.titleLabel?.text {
                    selectedAnswer = Int(text) ?? 0
                }
            }
            // If false, change the button's background color to yellow and its text to black.
            else {
                answerSelected = false
                answer.backgroundColor = UIColor(red:0.90, green:0.73, blue:0.17, alpha:1.0)
                answer.setTitleColor(UIColor.black, for: .normal)
                answer.accessibilityValue = ""
            }
        }
    }
    
    // Creates number labels below each tick on the number line
    func initializeNumberTexts() {
        
        // Variables for the display of the number labels.
        let textHeight = 100
        let textWidth = 40
        let spaceBetweenLineAndText:CGFloat=10.0
        
        // Variables for the measurement of the number labels.
        let lineRefBounds:CGRect = lineRef.bounds
        let distance = lineRef.distance
        
        // Create 5 number labels and make them accessible
        for i in 0...lineRef.numberOfPoints {
            let xDist = (distance*CGFloat(i))
            let minXOfLine = lineRef.center.x-(lineRefBounds.width/2)
            let maxYOfLine = lineRef.center.y+(lineRefBounds.height/2)
            let label = UILabel(frame: CGRect(
                    x: xDist + lineRef.offSetFromEdges + minXOfLine,
                    y: maxYOfLine + spaceBetweenLineAndText,
                    width: CGFloat(textWidth),
                    height: CGFloat(textHeight)
                )
            )
            
            // Determining the initial location (x, y) of [astronaut]
            if (i == desiredNumber) {
                // Setting [astronaut] to the correct location with correct dimensions.
                // Math explanation:
                // x:
                //    - Start from x value of '0' on the number line [minXOfLine].
                //    - Add the distance from '0' on the number line to the x value of the current tick [currentTick.frame.minX].
                //    - Since the width of the line is 30.0, 15.0 should be added to place Tommy on the middle of the tick.
                // y:
                //    - Start from the y value of the line on the screen [lineRef.center.y] + [lineRef.bounds.height] / 2
                //    - Subtract 10.0 since that's the space between the text and tick.
                //    - Subtract 20.0 since that's the width of the number line.
                //    - Subtract half the height of Tommy to place him on the number line.
                astronaut.center = CGPoint(
                    x: minXOfLine + xDist + lineRef.offSetFromEdges + 15.0,
                    y: lineRef.center.y + (lineRef.bounds.height/2) - 30.0 - astronaut.bounds.size.height / 2
                )
            }
            
            // Initializing the number label's color, text, and accessibility traits.
            label.text = String(i)
            label.font = UIFont(name: "Arial-BoldMT", size: 50)
            label.textColor = UIColor.white;
            label.isAccessibilityElement = true
            label.accessibilityTraits = UIAccessibilityTraits.playsSound
            label.isUserInteractionEnabled = true
            label.accessibilityLabel = String(i)
            
            // Adding the label to the view and appending it to the [accessibleNumbers] array.
            self.view.addSubview(label)
            accessibleNumbers.append(label)
        }
        
        // Adding all of the accessibility elements into the view's [accessibilityElements] array.
        self.view.accessibilityElements = [question, lineRef, astronaut, accessibleNumbers, zero, one, two, three, four, five, submitBtn, tutorial, levels];
    }
    
    // Called when the player hits the 'Submit' button.
    @IBAction func Submit(_ sender: Any) {
        
        // If-else based on if the selected answer is correct and whether to display the 'congrats' or 'try again' screen, respectively.
        if (selectedAnswer == desiredNumber) {
            performSegue(withIdentifier: "toCongrats", sender: self)
        }
        else {
            performSegue(withIdentifier: "toTryAgain", sender: self)
        }
    }
    
    // May need for future reference.
    func removePopOverView() {
    }
    
    // Based on whether the player answered the question correctly, this function will direct the player to either incorrect/correct popup window
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var tryAgainVC=segue.destination as? IncorrectPopUpViewController
        
        //If the player answered the question incorrectly, he/she needs to try the same round again.
        if (tryAgainVC != nil){
            tryAgainVC?.previousOneVCNum = desiredNumber
            tryAgainVC?.previousOneSelectedNum = selectedAnswer
            tryAgainVC?.previousOne = true
            
            // Determines whether to tell if the user's answer is less than or greater than the one selected.
            if (desiredNumber > selectedAnswer) {
                tryAgainVC?.previousGreater = true
            }
            else {
                tryAgainVC?.previousSmaller = true
            }
        }
        else {
            // If the player answered the question correctly, he/she will play the next round
            var rightVC = segue.destination as? CorrectPopUpViewController
            if (rightVC != nil) {
                rightVC!.parentOneVC=self
                rightVC!.numLevelsComplete=self.howManyLevelsAreDone
            }
            else {
                print("other vc")
            }
        }
    }
}
