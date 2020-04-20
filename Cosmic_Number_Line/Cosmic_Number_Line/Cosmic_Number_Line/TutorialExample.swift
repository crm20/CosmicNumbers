//
//  TutorialExample.swift
//  Cosmic_Number_Line
//
//  Created by Jonathan Chang on 4/19/20.
//  Copyright © 2020 Cosmic_Numbers. All rights reserved.
//
import Foundation
import UIKit

class TutorialExample: UIViewController {
    
    /// Typical @IBOutlets that will be in all tutorials.
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var astronaut: UIImageView!
    @IBOutlet weak var lineRef: Line!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    /// Variables used to detect the location of taps.
    var lineNumberLocations: [CGPoint] = [];
    var tickLocations: [CGRect] = [];
    
    /// Enums used for the switch cases.  the successional stages/subgoals the player has completed.
    /// *Note: You could also just use a regular integer and decrement/increment, but I used enums for exhaustive cases.
    enum stage {
        // case zero, one, two, ..., n
    }
    enum subGoal {
        // case zero, one, two, ..., n
    }
    
    /// Variables used to determine how many stages the player has completed.
    // stagesCompleted = .zero
    // subGoalsCompleted = .zero
    
    /// Required method intially called when a scene is loaded.
    /// Set the IBOutlets you want hidden here and any other items you generally want done in the beginning (Initialization, instruction text, etc).
    override func viewDidLoad() {
        // For example:
        /// lineRef.isHidden = true;
        /// astronaut.isHidden = true;
        /// ...
        
        // Setting accessibility:
        /// [variable].isAccessbilityElement = true;
        /// ....
        
        // Initializations that should occur.
        /// tickLocations = line.getTickCoords();
        /// ...
    }
    
    // The two primary methods to incur change in the tutorial are touchesBegan and onNext.
    
    /// Function that is called when the player taps [nextBtn]. Each time the user taps this button, a new stage should occur.
    /// This function is used to change the visibility of IBOutlets, the instructions' text, etc. The last case will perform a segue to the next level.
    /// Generally, a switch or if-else takes the current stage and determines what should happen next.
    @IBAction func onNext(_ sender: Any) {
        // For example:
        /// switch (stagesCompleted) {
        /// case .zero:
        ///    lineRef.isHidden = false;
        ///    stagesCompleted = .one
        ///    break;
        /// case .one:
        ///    break;
        /// ...
        /// case .n:
        /// performSegue(withIdentifier: [String]], sender: self);
        /// }
    }
    
    
    /// Function that is AUTOMATICALLY called when the user taps on the screen.
    /// Primary use is to determine if the user has tapped an object or a part of the screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            /// Position is a CGPoint. Generally this is sent to any of the hasTapped... functions below to continue the level's stages.
            let position = touch.location(in: view);
            // For example:
            /// if (hasTappedLineNumber(position)) {
            /// stagesCompleted = .two
            /// ....
            /// }
        
            // Test purposes only - you can remove this when you no longer need it.
            print(position);
        }
    }

    
    /// Function that resets the tutorial by basically reverting the scene back to the inital look of viewDidLoad.
    /// Generally, a sequence of hiding elements, changing functions of buttons, etc. occurs here.
    func resetTutorial() {
        // For example:
        /// lineRef.isHidden = true;
        /// astronaut.isHidden = true;
        /// ...
    }
    
    /// Helper function to change and set instructions.
    ///
    /// Parameter newText: instructions' text and accessbility label are changed to this string.
    /// Returns: Nothing.
    func changeInstructions(newText: String) {
        instructions.text = newText;
        instructions.accessibilityLabel = newText;
    }
    
    /// Function that is used to determine whether the player has tapped a line number (the line below the number line).
    ///
    /// Parameters:
    ///   - position: the location/point the user has tapped on. Will always be sent in the touchesBegan function.
    ///   - specificNumber: optional integer used when the user wants the player to tap on a specific line number. The default is set to -1 for try-catch purposes.
    /// Returns: true if the user has tapped a line number and false if they have not.
    /// *Math explanation can be found in LevelOneViewController.
    func hasTappedLineNumber(position: CGPoint, specificNumber: Int? = -1) -> Bool {
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
    
    /// Function that is used to determine whether the player has tapped a tick.
    ///
    /// Parameters:
    ///   - position: the location/point the user has tapped on. Will always be sent in the touchesBegan function.
    ///   - specificTick: optional integer used when the user wants the player to tap on a specific tick. The default is set to -1 for try-catch purposes.
    /// Returns: True if the user has tapped a line number and false if they have not.
    /// *Math explanation can be found in LevelOneViewController.
    func hasTappedTick(position: CGPoint, specificTick: Int? = -1) -> Bool {
        // The boundary of the number line.
        let lineRefBounds:CGRect = lineRef.bounds
        
        // The distance from the left side of the screen and the leftmost tick value of the line number (i.e. offset)
        let minXOfLine = CGFloat(lineRef.center.x - (lineRefBounds.width/2))
        
        // The baseline y value of the number line.
        let maxYOfLine = CGFloat(lineRef.center.y + (lineRefBounds.height/2))

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
    
    /// Function that is used to determine whether the player has tapped on Tommy.
    ///
    /// Parameters:
    ///   - position: the location/point the user has tapped on. Will always be sent in the touchesBegan function.
    /// Returns: True if the user has tapped a on Tommy and false if they have not.
    /// *Math is similar to setting Astronaut Tommy on the number line.
    func hasTappedTommy(position: CGPoint) -> Bool {
        let astronautLocation = astronaut.center;
        return (position.x <= astronautLocation.x + astronaut.bounds.size.width / 2 && position.x >= astronautLocation.x - astronaut.bounds.size.width / 2 &&
            position.y <= astronautLocation.y + astronaut.bounds.size.height / 2 && position.y >= astronautLocation.y - astronaut.bounds.size.height / 2);
    }

    
    /// Function that is called when the player taps [tutorialBtn]' button.
    /// Resets the tutorial via the resetTutorial method.
    @IBAction func tutorialButtonTapped(_ sender: Any) {
        resetTutorial();
    }
    
    /// Function that is called when the player taps [skipBtn]. Just sends them to the next level with a performSegue.
    @IBAction func skipBtnTapped(_ sender: Any) {
        // performSegue(withIdentifier: [String], sender: self);
    }
    
    /// Function that is called when the player taps [backBtn]. Just goes back one stage/subgoal and the respective changes with it.
    @IBAction func backBtnTapped(_ sender: Any) {

    }
    
    /// Unwind function that is called from clicking the 'Tutorial' button in the game scene. (e.g. Clicking the 'Tutorial' button in LevelOneGame )
    /// Since it's unwinded, we just reset the tutorial via the resetTutorial method.
    @IBAction func unwindToLevelOneTutorialSelector(_ sender: UIStoryboardSegue) {
        // When unwinded, the screen should return back to the original tutorial state.
        resetTutorial();
    }
}
