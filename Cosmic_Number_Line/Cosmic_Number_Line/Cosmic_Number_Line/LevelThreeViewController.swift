//
//  LevelThreeViewController.swift
//  Cosmic_Number_Line
//
//  Created by hyunc on 3/21/20.
//  Copyright © 2020 Cosmic_Numbers. All rights reserved.
//

import UIKit

class LevelThreeViewController: UIViewController {
    

    @IBOutlet weak var Tutorial3: UILabel!
    @IBOutlet weak var levels: UIButton!
    @IBOutlet weak var tutorial: UIButton!
    @IBOutlet weak var astronaut: UIImageView!
    @IBOutlet weak var lineRef: Line!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var smaller: UIButton!
    @IBOutlet weak var bigger: UIButton!
    
    
    // Variables used to determine the correct answer for the buttons..
    /// Note: the [desiredNumber]  can be any value from 0 -5. However, for tutorial sake, it is hardcoded to be three as it forces the player to investigate halfway through the number line before finding Tommy.
    var desiredNumber = 2;
    var astronautNumber = 3;
    var accessibleNumbers:[UIView] = []
    var answerArray: [UIButton] = []
    var selectedAnswer = ""
    var answerSelected = false
    
    // Variables that are used to detect the location of taps.
    var lineNumberLocations: [CGPoint] = [];
    var tickLocations: [CGRect] = [];

    // Variables for the successional stages/subgoals the player has completed.
    enum stage {
        case omega, zero, one, two, three
    }
    enum subGoal {
        case zero, one
    }
    
    // Variable that represents the amount of stages completed. Initially set to stage zero.
    var stagesCompleted = stage.zero;
    var subGoalCompleted = subGoal.zero;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // save the UIbuttons to the array
        answerArray = [smaller, bigger]
        
        // update the position of the astronaut
        let linerefbounds:CGRect=lineRef.bounds
        var minXOfLine = lineRef.center.x-(linerefbounds.width/2) - 30
        astronaut.frame = CGRect(x: minXOfLine + ((linerefbounds.width-40) / 5 * CGFloat(astronautNumber)),  y: lineRef.center.y, width: astronaut.frame.size.width, height: astronaut.frame.size.height)
        // Setting accessibility status and labels.
        isAccessibilityElement = true;
        instructions.isAccessibilityElement = true;
        skipBtn.isAccessibilityElement = true;
        skipBtn.accessibilityLabel = "Skip"
        backBtn.isAccessibilityElement = true;
        backBtn.accessibilityLabel = "Back"
        // Calling the function resetTutorial to hide the IBOutlet's.
        resetTutorial();
    }
    
    @IBAction func onNext(_ sender: Any) {
        // Switch statement that determines the visibility of elements on the scene based on which stage the player is on.
        // Instructions are also changed during each stage/step of the stage.
        switch(stagesCompleted) {
                
            // Initial stage of simply tapping the [nextBtn].
            case .omega:
                stagesCompleted = .zero;
                
            // Stage 0: Renders the number line.
            case .zero:
                if (accessibleNumbers.count != 0) {
                    changeLineNumberVisibility(isVisible: true)
                } else {
                    initializeNumberTexts();
                }
                nextBtn.isEnabled = false;
                lineRef.isHidden = false;
                astronaut.isHidden = false;

                changeInstructions(newText: "First tap on any number on the number line.");
                break;
            
            case .one:
                nextBtn.isEnabled = false;
                if ("Bigger" != selectedAnswer) {
                    changeInstructions(newText: "Tap the number of Astronaut Tommy's location on the number line. Compare the number below.");
                }
                break;
            
            case .two:
                tutorial.isHidden = false;
                levels.isHidden = false;
                nextBtn.setTitle("Finish", for: .normal);
                changeInstructions(newText: "Congratulations!\n To continue, split tap the next button.\n If you want to go to to other levels or redo the tutorial,\n two buttons have been added on the top, lefthand side of the screen.");
                stagesCompleted = stage.three;
                nextBtn.isEnabled = true;
                break;
            
            case .three:
                performSegue(withIdentifier: "toLevelThree", sender: self);
        }
    }
    
    // Secondary function that works in conjunction with onNext to create the tutorial experience.
    // It detects the user's taps and, based on location of the tap and the current stage, it changes the instructions.
    // This method is automatically called when the user taps the screen.
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view);
            switch(stagesCompleted) {
                
                case .zero:
                // First subgoal.
                    if (subGoalCompleted == .zero && hasTappedLineNumber(position: position)) {
                        changeInstructions(newText: "Now find Astronaut Tommy's Location and drag your finger below to find his number. Tap it to select.");
                        subGoalCompleted = .one;
                        
                    } else if (subGoalCompleted == .one && hasTappedLineNumber(position: position, specificNumber: 3)) {
                        
                        changeInstructions(newText: "Great! Now we know that Astronaut Tommy is located on the number 3. Tap 'Next' to continue.");
                        subGoalCompleted = subGoal.zero;
                        stagesCompleted = stage.one;
                        nextBtn.isEnabled = true;
                        //changeInstructions(newText: "Now, is Astronaut Tommy’s location smaller or bigger than 2?\n Tap on the correct answer choice out of the two below the number line.");
                        //subGoalCompleted = .zero;
                    }
                case .one:
                    if (hasTappedLineNumber(position: position, specificNumber: 3)) {
                        smaller.isHidden=false;
                        bigger.isHidden=false;
                        changeInstructions(newText: "Is Astronaut Tommy's location smaller or bigger than 2? Select from the two answer choices below the number line.");
                    }
                    break;
                
                
                
                default:
                    print("Player has completed all levels. Default case is required to meet Swift's exhaustive switch cases.")
            }
        }
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
                    selectedAnswer = text
                }
            }
            else {
                answerSelected = false
                answer.backgroundColor = UIColor(red:0.90, green:0.73, blue:0.17, alpha:1.0)
                answer.setTitleColor(UIColor.black, for: .normal)
                answer.accessibilityValue = ""
            }
        }
        // Determining the next stage.
        if (stagesCompleted == .one) {
            if (selectedAnswer == "Bigger") {
                // Second Goal
                changeInstructions(newText: "Good job!\n Split tap the next button for the final stage of the tutorial.");
                stagesCompleted = stage.two;
                nextBtn.isEnabled = true;
            } else {
                changeInstructions(newText: "Not quite. Try again!");
                stagesCompleted = stage.one;
                nextBtn.isEnabled = true;
            }
        }
    }
    @IBAction func skipBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "toLevelThree", sender: self);
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        // Implement later when you have the time.
        switch (stagesCompleted) {
        case .omega:
            break;
        case .zero:
            break;
        case .one:
            break;
        case .two:
            break;
        case .three:
            break;
        }
    }
    
    func initializeNumberTexts(){
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
            let xDist = (distance*CGFloat(i))
            var minXOfLine = lineRef.center.x-(linerefbounds.width/2)
            var maxYOfLine = lineRef.center.y+(linerefbounds.height/2)
            let label = UILabel(frame: CGRect(x: xDist+lineRef.offSetFromEdges + minXOfLine, y: maxYOfLine+spaceBetweenLineAndText, width: CGFloat(textWidth), height: CGFloat(textHeight)))
            
            lineNumberLocations.append(label.center);
            
            label.isAccessibilityElement = true
            label.text = String(i)
            label.font = UIFont(name: "Arial-BoldMT", size: 50)
            label.textColor = UIColor.white;
            self.view.addSubview(label)
            label.accessibilityTraits = UIAccessibilityTraits.playsSound
            label.isUserInteractionEnabled = true
            label.accessibilityLabel = String(i)
            accessibleNumbers.append(label)
            
            // Determining the initial location (x, y) of [astronaut]
            if (i == astronautNumber) {
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
            
            i += 1;
        }
        self.view.accessibilityElements = [lineRef, astronaut, accessibleNumbers, smaller, bigger, nextBtn, tutorial, levels];
    }
        
    func resetTutorial() {
        // Resetting [stagesCompleted] back to 0.
        stagesCompleted = stage.zero;
        subGoalCompleted = subGoal.zero;
        
        // Hiding IBOutlet's.
        levels.isHidden = true;
        tutorial.isHidden = true;
        smaller.isHidden = true;
        bigger.isHidden = true;
        astronaut.isHidden = true;
        lineRef.isHidden = true;
        
        // Hiding ticks for [lineRef].
        changeLineNumberVisibility(isVisible: false);
        
        // Resetting the chosen button's color back and resetting [selectedAnswer].
        bigger.backgroundColor = UIColor(red:0.90, green:0.73, blue:0.17, alpha:1.0);
        smaller.backgroundColor = UIColor(red:0.90, green:0.73, blue:0.17, alpha:1.0);
        bigger.setTitleColor(UIColor.black, for: .normal);
        smaller.setTitleColor(UIColor.black, for: .normal);
        bigger.accessibilityValue = "";
        smaller.accessibilityValue = "";
        selectedAnswer = "";
        
        // Resetting [nextBtn]'s title text.
        nextBtn.setTitle("Next", for: .normal);
        
        // Resetting the instruction text.
        changeInstructions(newText: "Now we will compare Astronaut Tommy’s Location with an another number! Find and tap the next button on the bottom right to continue.");
    }
    
    func changeLineNumberVisibility(isVisible: Bool) {
        // Checks for the initial call by viewDidLoad() when [accessibleNumber] is empty.
        if (accessibleNumbers.count != 0) {
            if (isVisible) {
                for number in accessibleNumbers {
                    number.isHidden = false;
                }
            } else {
                for number in accessibleNumbers {
                    number.isHidden = true;
                }
            }
        }
    }
    
    func changeInstructions(newText: String) {
        instructions.text = newText;
        instructions.accessibilityLabel = newText;
    }
    
    func hasTappedLineNumber(position: CGPoint, specificNumber: Int? = -1) -> Bool {
        // Math explanation:
        // x: 40 is the width of the number, but we start from the center, so +20 encapsulates the entire number's width. We add another 10 for margin of error.
        // y: 100 is the height of the number, but we start from the center, so +50 encapsulates the entire number's height. We add another 10 for margin of error.
        if (specificNumber == -1) {
            for number in lineNumberLocations {
                if (position.x <= number.x + 30 && position.x >= number.x - 30 &&
                    position.y <= number.y + 60 && position.y >= number.y - 60) {
                    return true;
                }
            }
        // Case of looking for a specific number.
        } else {
            let specificNumber = lineNumberLocations[specificNumber!]
            return (position.x <= specificNumber.x + 30 && position.x >= specificNumber.x - 30 &&
                position.y <= specificNumber.y + 60 && position.y >= specificNumber.y - 60);
        }
        return false;
    }
    
    @IBAction func tutorialButtonTapped(_ sender: Any) {
        resetTutorial();
    }
        
        
    @IBAction func unwindToLevelThreeTutorialSelector(_ sender: UIStoryboardSegue) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
