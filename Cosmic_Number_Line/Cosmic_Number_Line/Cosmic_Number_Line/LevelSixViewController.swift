//
//  LevelSixViewController.swift
//  Cosmic_Number_Line
//
//  Created by Joseph Kim on 4/20/20.
//  Copyright © 2020 Cosmic_Numbers. All rights reserved.
//
import UIKit
import AVFoundation

class LevelSixViewController: UIViewController {
    /// Basic IBOutlet variables.
    
    @IBOutlet weak var title6tutorial: UILabel!
    @IBOutlet weak var levels: UIButton!
    @IBOutlet weak var astronaut: UIImageView!
    @IBOutlet weak var tutorialBtn: UIButton!
    @IBOutlet weak var lineRef: Line!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var desiredNumber = 4;
    var accessibleNumbers:[UIView] = []
    var threshold=10
    var exampleVar:Int=0
    var holdingAstronaut:Bool=false
    var maxWaitingTime:Int=5
    var waitingTime:Int = 5
    var mostrecentTick:UIView?=nil
    var astronautOriginalPosition = CGPoint(x:0,y:0)
    var newSound: AVAudioPlayer?
    
    // Variables that are used to detect the location of taps.
    var lineNumberLocations: [CGPoint] = [];
    var tickLocations: [CGRect] = [];

    // Variables for the successional stages/subgoals the player has completed.
    enum stage {
        case omega, zero, one, two
    }
    
    // Variable that represents the amount of stages completed. Initially set to stage zero.
    var stagesCompleted = stage.zero;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        isAccessibilityElement = true;
        instructions.isAccessibilityElement = true;
        tutorialBtn.isAccessibilityElement = true;
        skipBtn.isAccessibilityElement = true;
        skipBtn.accessibilityLabel = "Skip"
        backBtn.isAccessibilityElement = true;
        backBtn.accessibilityLabel = "Back"
        instructions.numberOfLines = 0
        astronautOriginalPosition = astronaut.center

        resetTutorial();
    }
    // handles pressing of next button
    @IBAction func onNext( sender: Any) {
        switch(stagesCompleted) {
        case .omega:
            stagesCompleted = .zero;
            
        case .zero:
            tickLocations = lineRef.getTickCoords();
            
            astronaut.isHidden = false;
            lineRef.isHidden = false;
            stagesCompleted = stage.one
            initializeNumberTexts()
            changeInstructions(newText: "Find Astronaut Tommy near the top left corner of the iPad. Drag him to the answer of 3 + 1" + " and split tap next.");
            UIAccessibility.post(notification: .layoutChanged, argument: instructions);
            astronaut.center = astronautOriginalPosition
            break;
           case .one:
               let astronaut_positionX = astronaut.center.x
                   let astronaut_positionY = astronaut.center.y
                   let lineRefBounds:CGRect=lineRef.bounds
                   let minXOfLine = lineRef.center.x-(lineRefBounds.width/2)
                   let maxYOfLine = lineRef.center.y
               
                   if (astronaut_positionX >= lineRef.points[desiredNumber].bounds.minX+minXOfLine-40 && astronaut_positionX < lineRef.points[desiredNumber].bounds.maxX+minXOfLine+40
                       && astronaut_positionY >= maxYOfLine-70 &&
                       astronaut_positionY < maxYOfLine+100) {
                       astronaut.isHidden = true
                       changeInstructions(newText: "Great job! To practice some more addition, split tap next.");
                       UIAccessibility.post(notification: .layoutChanged, argument: instructions);
                       stagesCompleted = stage.two
                   } else {
                       changeInstructions(newText: "Try Again. Drag him to tick number 3 + 1" + " and split tap next.");
                       UIAccessibility.post(notification: .layoutChanged, argument: instructions);
                       astronaut.center = astronautOriginalPosition
               }
           case .two:
               performSegue(withIdentifier: "toLevelSix", sender: self);
            
        }

    }
    
    // resets tutorial but is also how first page is uploaded
    func resetTutorial() {
        stagesCompleted = stage.zero;
        
        lineRef.isHidden = false;
        astronaut.center = astronautOriginalPosition
        astronaut.isHidden = true
        changeInstructions(newText: "Let's see those addition skills you learned in Level 5! Solve 3 + 1. When you know the answer, split tap next.");
        UIAccessibility.post(notification: .screenChanged, argument: title6tutorial);
        let timer = Timer.scheduledTimer(withTimeInterval: 3.3, repeats: false, block: {timer in
            UIAccessibility.post(notification: .screenChanged, argument: self.instructions)
        });
    }
    // writes number below number line
    func initializeNumberTexts() {
        let lineRefBounds:CGRect=lineRef.bounds
        let spaceBetweenLineAndText:CGFloat = 10.0
        // Create 5 number labels and make them accessible
        for i in 0...lineRef.numberOfPoints {
            let xDist = (lineRef.distance*CGFloat(i))
            let minXOfLine = lineRef.center.x-(lineRefBounds.width/2)
            let maxYOfLine = lineRef.center.y+(lineRefBounds.height/2)
            let label = UILabel(frame: CGRect(
                    x: xDist+lineRef.offSetFromEdges + minXOfLine,
                    y: maxYOfLine+spaceBetweenLineAndText,
                    width: CGFloat(40.0),
                    height: CGFloat(100.0)
                )
            )
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
        self.view.accessibilityElements = [instructions, tutorialBtn, astronaut, lineRef, accessibleNumbers, nextBtn, skipBtn, backBtn, levels];
    }

    // skip button takes straight to level
    @IBAction func skipBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "toLevelSix", sender: self);
    }
    
    // Called when the 'back' button has been tapped. Goes back one stage in the tutorial.
    @IBAction func backBtnTapped(_ sender: Any) {
        switch (stagesCompleted) {
        case .omega:
            break;
        case .zero:
            stagesCompleted = stage.omega
            break;
        case .one:
                changeInstructions(newText: "Let's see those addition skills you learned in Level 5! Solve 3 + 1. When you know the answer, split tap next.");
                UIAccessibility.post(notification: .layoutChanged, argument: instructions);
                stagesCompleted = stage.zero
                astronaut.center = astronautOriginalPosition
                astronaut.isHidden = true
                break;
       case .two:
           changeInstructions(newText: "Drag him to tick number 3 + 1" + " and split tap next.")
           UIAccessibility.post(notification: .layoutChanged, argument: instructions);
           stagesCompleted = stage.one
           astronaut.center = astronautOriginalPosition
           break;
       }
    }
    
    // resets tutorial by tapping Tutorial Button
    @IBAction func tutorialButtonTapped(
        sender: Any) {
        resetTutorial();
    }
    @IBAction func unwindToLevelSixTutorialSelector(_ sender: UIStoryboardSegue) {
        resetTutorial();
    }
    // changes instructions in tutorial
    func changeInstructions(newText: String) {
        instructions.text = newText;
        instructions.accessibilityLabel = newText;
    }
            
        // Function that identifies where the player has dragged the astronaut.
    @IBAction func handlepan(recognizer:UIPanGestureRecognizer) {
            let focusedView=UIAccessibility.focusedElement(using:
                UIAccessibility.AssistiveTechnologyIdentifier.notificationVoiceOver)
            let translation = recognizer.translation(in:self.view)

            if let view = recognizer.view {

                // The followings are to find intersection (while the player drag the astronaut over other objects on the screen)
                var possibleViewsToIntersect:[UIView] = []
                
                for numlabel in accessibleNumbers{
                    possibleViewsToIntersect.append(numlabel)
                }
                
                let intersectingTicks:[UIView] = lineRef!.accessibleTicks.filter{
                            $0 != view && view.frame.intersects(CGRect(
                            x: $0.frame.minX+lineRef.frame.minX,
                            y: $0.frame.minY+lineRef.frame.minY,
                            width: $0.frame.width,
                            height: $0.frame.height)
                        )
                    }
                
                let intersectingNums:[UIView]=possibleViewsToIntersect.filter{$0 != view && view.frame.intersects($0.frame)}
                var intersectingViews=intersectingTicks
                
                for nums in intersectingNums {
                    intersectingViews.append(nums)
                }
                
                if (intersectingViews.count == 0){
                    mostrecentTick = nil
                }
                    
                // Makes sounds when the player drag the astronaut over objects
                else if (intersectingViews.count==1){
                    if (intersectingViews[0] != mostrecentTick) {
                        mostrecentTick=intersectingViews[0]
                        
                        let utterance = AVSpeechUtterance(string: intersectingViews[0].accessibilityLabel ?? "")
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                        utterance.rate = 0.5
                        utterance.volume=5
                        
                        let synthesizer = AVSpeechSynthesizer()
                        synthesizer.speak(utterance)
                    }
                } else if (intersectingViews.count==2) {
                    if (intersectingViews[1] != mostrecentTick) {
                        mostrecentTick=intersectingViews[1]
                        
                        let utterance = AVSpeechUtterance(string: intersectingViews[1].accessibilityLabel ?? "")
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                        utterance.rate = 0.5
                        utterance.volume = 5
                        
                        let synthesizer = AVSpeechSynthesizer()
                        synthesizer.speak(utterance)
                    }
                }
                if (translation.x >= -0.1 && translation.x <= 0.1 && translation.y >= -0.1 && translation.y <= 0.1 && holdingAstronaut){
//                    playSound()
                    holdingAstronaut = false
                    
                    // If statement that checks if the player has placed Tommy on a tick.
                    if (intersectingTicks != []) {
                        // [currentTick] refers to the tick [astronaut] is currently placed on top of.
                        let currentTick: UIView = intersectingTicks[intersectingTicks.count - 1];
                        
                        // [minXOfLine] is the coordinate x value of '0' on the number line.
                        let minXOfLine = lineRef.center.x - (lineRef.bounds.width/2)
                        
                        // 'Locking' Tommy on the [currentTick]
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
                            x: minXOfLine + currentTick.frame.minX + 15.0,
                            y: lineRef.center.y + (lineRef.bounds.height/2) - 30.0 - astronaut.bounds.size.height / 2
                        );
                        
                    // Returns Tommy back to the original position.
                    } else if (holdingAstronaut == false){
                        astronaut.center = astronautOriginalPosition
                    }
                    waitingTime = maxWaitingTime
                }
                else {
                    if (waitingTime < 0){
                        holdingAstronaut = true
                    }
                    else {
                        waitingTime -= 1
                        holdingAstronaut = false
                    }
                }
                view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
                
            }
            self.view.bringSubviewToFront(view)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
//        // Play drop sound when the player drops the astronaut
//        func playSound() {
//            guard let url = Bundle.main.url(forResource: "splat", withExtension: "mp3") else { return }
//
//            do {
//                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//                try AVAudioSession.sharedInstance().setActive(true)
//
//                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//                guard let player = player else { return }
//
//                player.play()
//
//            } catch let error {
//    //            print(error.localizedDescription)
//            }
//        }
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
