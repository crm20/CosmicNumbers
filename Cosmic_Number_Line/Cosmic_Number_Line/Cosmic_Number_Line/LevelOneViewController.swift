//
//  LevelOneViewController.swift
//  Cosmic_Number_Line
//
//  Created by hyunc on 3/21/20.
//  Copyright © 2020 Cosmic_Numbers. All rights reserved.
//

import UIKit

class LevelOneViewController: UIViewController {
    
    /// Basic IBOutlet variables.
    @IBOutlet weak var levels: UIButton!
    @IBOutlet weak var tutorial: UIButton!
    @IBOutlet weak var astronaut: UIImageView!
    @IBOutlet weak var lineRef: Line!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var zeroBtn: UIButton!
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fiveBtn: UIButton!
    @IBOutlet weak var instructions: UILabel!
    
    // Variables used to determine the correct answer for the buttons..
    /// Note: the [desiredNumber]  can be any value from 0 -5. However, for tutorial sake, it is hardcoded to be three as it forces the player to investigate halfway through the number line before finding Tommy.
    var desiredNumber = 3;
    var accessibleNumbers:[UIView] = []
    var answerArray: [UIButton] = []
    var selectedAnswer = 0
    var answerSelected = false
    
    // Variables that are used to detect the location of taps.
    var lineNumberLocations: [CGPoint] = [];
    var tickLocations: [CGRect] = [];

    // Enum that representations the successional stages the player has completed.
    enum stage {
        case omega
        case zero
        case one
        case two
        case three
        case four
        case five
    }
    
    // Enum that represents the subgoals the player has completed within each stage.
    enum subGoal {
        case zero
        case one
        case three
    }
    
    // Variable that represents the amount of stages completed. Initially set to stage zero.
    var stagesCompleted = stage.zero;
    var subGoalCompleted = subGoal.zero;

    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Saving the answer buttons into an array
        answerArray = [zeroBtn, oneBtn, twoBtn, threeBtn, fourBtn, fiveBtn];
        
        // Calling the function resetTutorial to hide the IBOutlet's.
        resetTutorial();
        
        // Setting accessibility status.
        isAccessibilityElement = true;
        instructions.isAccessibilityElement = true;
    }
    
    // Primary function of the tutorial. Called to reveal visibility of IBOutlet's and eventually is used to perform a segue.
    @IBAction func onNext(_ sender: Any) {

        // Switch statement that determines the visibility of elements on the scene based on which stage the player is on.
        // Instructions are also changed during each stage/step of the stage.
        switch(stagesCompleted) {
            
        // Initial stage of simply tapping the [nextBtn].
        case .omega:
            stagesCompleted = .zero;
            
        // Stage 0: Renders the number line.
        case .zero:
            // Setting the locations of the ticks.
            tickLocations = lineRef.getTickCoords();
            
            nextBtn.isEnabled = false;
            lineRef.isHidden = false;
            changeInstructions(newText: "Starting at the top left corner of the screen, drag your finger in a straight line down along the left side of the screen. Tap when you hear the “tick” sound!");
            break;
            
        // Stage 1: Renders the numbers for the [line].
        case .one:
            // Make the numbers visible or initialize them if they have not already been.
            if (accessibleNumbers.count != 0) {
                changeLineNumberVisibility(isVisible: true)
            } else {
                initializeNumberTexts();
            }
            nextBtn.isEnabled = false;
            changeInstructions(newText: "Directly below each tick is a number. This number tells you where you are on the number line. Drag your finger in a straight line down from any tick and tap the number!");
            break;
            
        // Case 2: Renders [astronaut].
        case .two:
            // Place astronaut Tommy on the number line.
            astronaut.isHidden = false;
            nextBtn.isEnabled = false;
            changeInstructions(newText: "Astronaut Tommy is on a tick mark. Find the first tick mark then drag your finger to the right to find Astronaut Tommy. Tap on him when you find him!");
            break;
            
        // Case 3: Renders the buttons.
        case .three:
            nextBtn.isEnabled = false;
            if (desiredNumber != selectedAnswer) {
                changeInstructions(newText: "Find Astronaut Tommy, then find the number below him. Tap that number!");
            }
            break;
            
        // Case 4: Renders [tutorial] and [level], changest [nextBtn]'s text to 'Finish,' and disabling the other buttons.
        case .four:
            tutorial.isHidden = false;
            levels.isHidden = false;
            nextBtn.setTitle("Finish", for: .normal);
            nextBtn.isEnabled = false;
            changeInstructions(newText: "Congratulations! To continue, split tap the next button. If you want to go to to other levels or redo the tutorial, two buttons have been added on the top, lefthand side of the screen.");
            
            stagesCompleted = stage.five;
            nextBtn.isEnabled = true;
            break;
            
        // Case 5: Changes the function of [nextBtn].
        case .five:
            performSegue(withIdentifier: "toLevelOne", sender: self);
        
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
                if (subGoalCompleted == .zero && hasTappedTick(position: position)) {
                    changeInstructions(newText: "You found the number line! Now drag your finger in a straight line to the right, following the tick marks on the number line. Tap when you hear the last tick!");
                    subGoalCompleted = subGoal.one;
                // Second subgoal.
                } else if (subGoalCompleted == .one && hasTappedTick(position: position, specificTick: 5)) {
                    changeInstructions(newText: "Now split tap the next button in the bottom right corner.");
                    subGoalCompleted = subGoal.zero;
                    stagesCompleted = stage.one;
                    nextBtn.isEnabled = true;
                }
                break;
                
            case .one:
                // First subgoal.
                if (subGoalCompleted == .zero && hasTappedLineNumber(position: position)) {
                    changeInstructions(newText: "Now drag your finger to the right, listening to all the numbers. This number line ranges from 0 – 5. Tap when you hear number five!");
                    subGoalCompleted = .one;
                // Second subgoal.
                } else if (subGoalCompleted == .one && hasTappedLineNumber(position: position, specificNumber: 5)) {
                    changeInstructions(newText: "Good job! Now split tap the next button!");
                    stagesCompleted = stage.two;
                    nextBtn.isEnabled = true;
                    subGoalCompleted = subGoal.zero;
                }
                break;
                
            case .two:
                // First subgoal.
                if (subGoalCompleted == .zero && hasTappedTommy(position: position)) {
                    changeInstructions(newText: "Now, drag your finger down directly below him to find his number. Tap when you hear his number!");
                    subGoalCompleted = subGoal.one;
                    
                // Second subgoal.
                } else if (subGoalCompleted == .one && hasTappedLineNumber(position: position, specificNumber: 3)) {
                    // Second subgoal
                    changeInstructions(newText: "Great! Now that you know how to find Astronaut Tommy and his location, split tap the next button for the final stage of the tutorial.");
                    stagesCompleted = stage.three;
                    nextBtn.isEnabled = true;
                    subGoalCompleted = subGoal.zero;

                }
                
            case .three:
                // First subgoal.
                if (hasTappedLineNumber(position: position, specificNumber: 3)) {
                    zeroBtn.isHidden = false;
                    oneBtn.isHidden = false;
                    twoBtn.isHidden = false;
                    threeBtn.isHidden = false;
                    fourBtn.isHidden = false;
                    fiveBtn.isHidden = false;
                    changeInstructions(newText: "Number buttons are in a horizontal row along the bottom of the screen. Drag your finger to the bottom left corner to find the first number, 0. Drag right until you find the same number that Astronaut Tommy is on and split tap it!");
                }
                break;
                
            default:
                print("Player has completed all levels. Default case is required to meet Swift's exhaustive switch cases.")
            }
        }
    }
    
    // Function that relates to [oneBtn], [twoBtn], ... [fiveBtn]. Keeps track of the selected answer and highlight the button the user tapped on. In addition, it's used in stage three of the tutorial when the user determines Tommy's location.
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
        
        // Determining the next stage.
        if (stagesCompleted == .three || stagesCompleted == .four) {
            if (selectedAnswer == desiredNumber) {
                // Second Goal
                changeInstructions(newText: "Good job! Split tap the next button for the final stage of the tutorial.");
                stagesCompleted = stage.four;
                nextBtn.isEnabled = true;
            } else {
                let additionalInformation = selectedAnswer < desiredNumber ? "less than" : "greater than";
                changeInstructions(newText: "Not quite. Your answer is " + additionalInformation + " than Tommy's location.");
                stagesCompleted = stage.three;
                nextBtn.isEnabled = true;
            }
        }
    }
    
    // Function that initalizes the numbers located below the number line.
    func initializeNumberTexts() {
        
        // Variables for the display of the number labels.
        let textHeight = 100
        let textWidth = 40
        let spaceBetweenLineAndText:CGFloat = 10.0
        
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

            lineNumberLocations.append(label.center);
            
            // Determining the initial location (x, y) of [astronaut]
            if (i == desiredNumber) {
                astronaut.center = CGPoint(
                    x: minXOfLine + xDist + lineRef.offSetFromEdges + 15.0,
                    y: lineRef.center.y + (lineRef.bounds.height/2) - 30.0 - astronaut.bounds.size.height / 2
                )
            }
            
            // Initializing the number label's color, text, and accessibility traits.
            label.text = String(i)
            label.font = UIFont(name: "Arial-BoldMT", size: 40)
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
        self.view.accessibilityElements = [lineRef, astronaut, accessibleNumbers, zeroBtn, oneBtn, twoBtn, threeBtn, fourBtn, fiveBtn, nextBtn, tutorial, levels];
    }
    
    // Function that resets the tutorial. Hides visibility of IBOutlet's, resets instructions, etc.
    func resetTutorial() {
        // Resetting [stagesCompleted] back to 0.
        stagesCompleted = stage.zero;
        subGoalCompleted = subGoal.zero;
        
        // Hiding IBOutlet's.
        levels.isHidden = true;
        tutorial.isHidden = true;
        zeroBtn.isHidden = true;
        oneBtn.isHidden = true;
        twoBtn.isHidden = true;
        threeBtn.isHidden = true;
        fourBtn.isHidden = true;
        fiveBtn.isHidden = true;
        astronaut.isHidden = true;
        lineRef.isHidden = true;
        
        // Hiding ticks for [lineRef].
        changeLineNumberVisibility(isVisible: false);
        
        // Resetting the chosen button's color back and resetting [selectedAnswer].
        answerArray[selectedAnswer].backgroundColor = UIColor(red:0.90, green:0.73, blue:0.17, alpha:1.0)
        answerArray[selectedAnswer].setTitleColor(UIColor.black, for: .normal)
        answerArray[selectedAnswer].accessibilityValue = ""
        selectedAnswer = 0;
        
        // Resetting [nextBtn]'s title text.
        nextBtn.setTitle("Next", for: .normal);
        
        // Resetting the instruction text.
        changeInstructions(newText: "Starting in the bottom right corner of the iPad, drag your finger around to locate the Submit button. Keep your finger on the screen and split tap to select the Submit button.");
    }
    
    // Shows the numbers below [lineRef] based on the given [isVisible] parameter. True makes the numbers visible while false makes them invisible.
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
    
    // Helper method to change the instructions' text and accessbility label.
    func changeInstructions(newText: String) {
        instructions.text = newText;
        instructions.accessibilityLabel = newText;
    }
    
    // Function that determines if the player has tapped on a line number.
    // [position] refers to the point that the player has clicked on.
    // [specificNumber] is optional and only used if there is a specific number the user wants the player to tap.
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
    
    // Function that determines if the player has tapped on a tick.
    // [position] refers to the point that the player has clicked on.
    // [specificNumber] is optional and only used if there is a specific tick the user wants the player to tap.
    func hasTappedTick(position: CGPoint, specificTick: Int? = -1) -> Bool {
        // The boundary of the number line.
        let lineRefBounds:CGRect = lineRef.bounds
        
        // The distance from the left side of the screen and the leftmost tick value of the line number (i.e. offset)
        let minXOfLine = CGFloat(lineRef.center.x - (lineRefBounds.width/2))
        
        // The baseline y value of the number line.
        let maxYOfLine = CGFloat(lineRef.center.y + (lineRefBounds.height/2))
        
        // Math explanation:
        // x: take the x value of the coordinate and add the offset and the tick's width to get the rightmost x value. Don't add the line width to get the leftmost x value.
        // y: the baseline is set as the lower bound and the higher bound is found by subtracting it from the tick's height.
        if (specificTick == -1) {
            for tick in tickLocations {
                if (position.x <= tick.minX + minXOfLine + lineRef.lineWidth && position.x >= tick.minX + minXOfLine &&
                    position.y <= maxYOfLine && position.y >= maxYOfLine - lineRef.lineHeight) {
                    return true;
                }
            }
        // Case of looking for a specific tick.
        } else {
            let specificTick = tickLocations[specificTick!]
            if (position.x <= specificTick.minX + minXOfLine + lineRef.lineWidth && position.x >= specificTick.minX + minXOfLine &&
                position.y <= maxYOfLine && position.y >= maxYOfLine - lineRef.lineHeight) {
                return true;
            }
        }
        return false;
    }
    
    // Function that determines if the player has tapped on Astronaut Tommy.
    // [position] refers to the point that the player has clicked on.
    func hasTappedTommy(position: CGPoint) -> Bool {
        // Math is similar to setting Astronaut Tommy on the number line.
        let astronautLocation = astronaut.center;
        return (position.x <= astronautLocation.x + astronaut.bounds.size.width / 2 && position.x >= astronautLocation.x - astronaut.bounds.size.width / 2 &&
            position.y <= astronautLocation.y + astronaut.bounds.size.height / 2 && position.y >= astronautLocation.y - astronaut.bounds.size.height / 2);
    }
    
    // Resets the tutorial.
    @IBAction func tutorialButtonTapped(_ sender: Any) {
        resetTutorial();
    }
    
    // Unwind function that results from clicking the 'tutorial' button in the LevelOneGame.swift.
    @IBAction func unwindToLevelOneTutorialSelector(_ sender: UIStoryboardSegue) {
        // When unwinded, the screen should return back to the original tutorial state.
        resetTutorial();
    }
}
