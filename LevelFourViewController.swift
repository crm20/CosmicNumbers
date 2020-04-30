//
//  LevelFourViewController.swift
//  Cosmic_Number_Line
//
//  Created by hyunc on 3/21/20.
//  Copyright © 2020 Cosmic_Numbers. All rights reserved.
//
import UIKit
import AVFoundation

class LevelFourViewController: UIViewController {
    

    @IBOutlet weak var lineRef: Line!
    @IBOutlet weak var title4tutorial: UILabel!
    @IBOutlet weak var astronaut: UIImageView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var questionNum: UILabel!
    @IBOutlet weak var pickerItem: UIPickerView!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var astronautTwo: UIImageView!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tutorial: UIButton!
    @IBOutlet weak var levels: UIButton!
    
    
    
    // Variables used to determine the correct answer for the buttons..
    /// Note: the [desiredNumber]  can be any value from 0 -5. However, for tutorial sake, it is hardcoded to be three as it forces the player to investigate halfway through the number line before finding Tommy.
    var desiredNumber = 4;
    var astronautNumber = 3;
    var accessibleNumbers:[UIView] = []
    var answerArray: [String] = []
    var selectedAnswer = ""
    var answerSelected = false
    let pickerData = ["Greater than", "Equal to", "Less than"]
    
    // Variables that are used to detect the location of taps.
    var lineNumberLocations: [CGPoint] = [];
    var tickLocations: [CGRect] = [];

    // Variables for the successional stages/subgoals the player has completed.
    enum stage {
        case omega, zero, one, two, three
    }
    enum subGoal {
        case zero, one, two
    }
    
    // Variable that represents the amount of stages completed. Initially set to stage zero.
    var stagesCompleted = stage.zero;
    var subGoalCompleted = subGoal.zero;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // save the UIbuttons to the array
        answerArray = ["Greater Than", "Less Than", "Equal to"]
        
        // update the position of the astronaut
        let linerefbounds:CGRect=lineRef.bounds
        var minXOfLine = lineRef.center.x-(linerefbounds.width/2) - 30
        astronaut.frame = CGRect(x: minXOfLine + ((linerefbounds.width-40) / 5 * CGFloat(astronautNumber)),  y: lineRef.center.y, width: astronaut.frame.size.width, height: astronaut.frame.size.height)
        pickerItem.dataSource = self
        pickerItem.delegate = self
        // Setting accessibility status and labels.
        isAccessibilityElement = true;
        instructions.isAccessibilityElement = true;
        skipBtn.isAccessibilityElement = true;
        skipBtn.accessibilityLabel = "Skip"
        backBtn.isAccessibilityElement = true;
        backBtn.accessibilityLabel = "Back"
        pickerItem.isAccessibilityElement = true
        pickerItem.accessibilityLabel = "pickerItem"
        astronaut.isHidden = true;
        
        // Calling the function resetTutorial to hide the IBOutlet's.
        resetTutorial();
    }
    
    
    @IBAction func onNext(_ sender: Any) {
        astronaut.isHidden = false;
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
                //astronaut.isHidden = true;
                pickerItem.isHidden = false;

                changeInstructions(newText: "First, find and select Equal to on the picker item and click Next");
                break;
            
            case .one:
                    performSegue(withIdentifier: "toLevelFour", sender: self);
            
            case .two:
                //nextBtn.isEnabled = false;
                if ("Less Than" != selectedAnswer) {
                    changeInstructions(newText: "Tap the number of Astronaut Tommy's location on the number line. Compare the number below.");
                }
                break;
            
            case .three:
                performSegue(withIdentifier: "toLevelFour", sender: self);
        }
    }
    
    // Secondary function that works in conjunction with onNext to create the tutorial experience.
    // It detects the user's taps and, based on location of the tap and the current stage, it changes the instructions.
    // This method is automatically called when the user taps the screen.
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view);
            nextBtn.isEnabled = false
            switch(stagesCompleted) {
                
                case .zero:
                // First subgoal.
                    //Go to here
                    if (subGoalCompleted == .zero && selectedAnswer == "Equal to" ) {
                        changeInstructions(newText: "Awesome! Now is Tommy's position less than, greater than or equal to 3?");
                        subGoalCompleted = .one;
                        
                    } else if (subGoalCompleted == .one && selectedAnswer == "Greater than") {
                        
                        changeInstructions(newText: "Awesome work, Click Next to continue to level four");
                        subGoalCompleted = .two;
                        stagesCompleted = stage.one;
                        nextBtn.isEnabled = true;
                    }
                default:
                    print("Player has completed all levels. Default case is required to meet Swift's exhaustive switch cases.")
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
    }
    @IBAction func skipBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "toLevelFour", sender: self);
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
            if (i == desiredNumber) {
                astronaut.center = CGPoint(
                    x: minXOfLine + xDist + lineRef.offSetFromEdges + 15.0,
                    y: lineRef.center.y + (lineRef.bounds.height/2) - 30.0 - astronaut.bounds.size.height / 2
                )
            }
            
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
        self.view.accessibilityElements = [lineRef, astronaut, accessibleNumbers, nextBtn, tutorial, levels, pickerItem];
    }
        
    func resetTutorial() {
        // Resetting [stagesCompleted] back to 0.
        stagesCompleted = stage.zero;
        subGoalCompleted = subGoal.zero;
        
        // Hiding IBOutlet's.
        //levels.isHidden = true;
        //tutorial.isHidden = true;
        //astronaut.isHidden = true;
        //lineRef.isHidden = true;
        pickerItem.isHidden = false
        
        // Hiding ticks for [lineRef].
        changeLineNumberVisibility(isVisible: false);
        
        // Resetting the chosen button's color back and resetting [selectedAnswer].
        selectedAnswer = "";
        
        // Resetting [nextBtn]'s title text.
        nextBtn.setTitle("Next", for: .normal);
        
        // Resetting the instruction text.
        changeInstructions(newText: "Now we are going to introduce the picker item. Click next to continue.");

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
    
    func hasTappedTommy(position: CGPoint) -> Bool {
        // Math is similar to setting Astronaut Tommy on the number line.
        let astronautLocation = astronaut.center;
        return (position.x <= astronautLocation.x + astronaut.bounds.size.width / 2 && position.x >= astronautLocation.x - astronaut.bounds.size.width / 2 &&
            position.y <= astronautLocation.y + astronaut.bounds.size.height / 2 && position.y >= astronautLocation.y - astronaut.bounds.size.height / 2);
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
    

        
        
    @IBAction func unwindToLevelFourTutorialSelector(_ sender: UIStoryboardSegue) {}

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LevelFourViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickervIEW: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        selectedAnswer = pickerData[row] as String
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Arial", size: 35)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = pickerData[row]
        pickerLabel?.textColor = UIColor.white
        
        return pickerLabel!
    }
}
