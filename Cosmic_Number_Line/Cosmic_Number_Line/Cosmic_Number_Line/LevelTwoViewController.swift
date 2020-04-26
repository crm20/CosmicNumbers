//
//  LevelTwoViewController.swift
//  Cosmic_Number_Line
//
//  Created by hyunc on 3/21/20.
//  Copyright © 2020 Cosmic_Numbers. All rights reserved.
//

import UIKit
import AVFoundation

class LevelTwoViewController: UIViewController {

    // Basic IBOutlet Variables.
    @IBOutlet weak var lineRef: Line!
    @IBOutlet weak var astronaut: UIImageView!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var tutorialBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    // Variables that are used to detect the location of taps.
    var lineNumberLocations: [CGPoint] = [];
    var tickLocations: [CGRect] = [];
    
    // Variables for the tutorial.
    var desiredNumber=3
    var threshold=10
    var exampleVar:Int=0
    var howManyLevelsAreDone:Int=0
    var holdingAstronaut:Bool=false
    var maxWaitingTime:Int=5
    var waitingTime:Int = 5
    var mostrecentTick:UIView?=nil
    var accessibleNumbers:[UIView]=[]
    var astronautOriginalPosition = CGPoint(x:0,y:0)
    var newSound: AVAudioPlayer?
    var player: AVAudioPlayer?
    
    // Variables for the successional stages/subgoals the player has completed.
    enum stage {
        case zero, one
    }
    enum subGoal {
        case zero, one
    }
    
    var stagesCompleted = stage.zero;
    var subGoalCompleted = subGoal.zero;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializing variables.
        astronautOriginalPosition = astronaut.center;
        tickLocations = lineRef.getTickCoords();
        
        // Setting accessibility status and labels.
        isAccessibilityElement = true;
        instructions.isAccessibilityElement = true;
        skipBtn.isAccessibilityElement = true;
        skipBtn.accessibilityLabel = "Skip"
        backBtn.isAccessibilityElement = true;
        backBtn.accessibilityLabel = "Back"
        
        // Setting the scene.
        resetTutorial();
    }
    
    @IBAction func onNext(_ sender: Any) {
        switch(stagesCompleted) {
        case .zero:
            astronaut.isHidden = false;
            changeInstructions(newText: "Tommy is currently located at the top left section of the screen, waiting for you to help him. Tap when you find him!")
            nextBtn.isEnabled = false;
            break;
        case .one:
            performSegue(withIdentifier: "toLevelTwo", sender: self);
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view);
            
            switch(subGoalCompleted) {
            case .zero:
                if (hasTappedTommy(position: position)) {
                    changeInstructions(newText: "Good job! You've found Tommy! Tommy now needs to move to the beginning of the number line. Place your finger on him and drag him down until you hear the first tick noise.")
                    tickLocations = lineRef.getTickCoords();
                }
                break;
            case .one:
                let lineRefBounds:CGRect = lineRef.bounds
                let minXOfLine = lineRef.center.x-(lineRefBounds.width/2)
                let maxYOfLine = CGFloat(lineRef.center.y + (lineRefBounds.height/2))
                let specificTick = tickLocations[5]
                // Checking if the user has tapped line number five while Tommy is on tick five.
                if (hasTappedLineNumber(position: position, specificNumber: 5) &&
                    astronaut.center.x <= specificTick.minX + minXOfLine + lineRef.lineWidth && astronaut.center.x >= specificTick.minX + minXOfLine &&
                    astronaut.center.y <= maxYOfLine && astronaut.center.y >= maxYOfLine - lineRef.lineHeight) {
                    changeInstructions(newText: "Tommy is back to where he belongs, but he still needs your help! Tap the 'next' button to help him again!")
                    nextBtn.isEnabled = true;
                    stagesCompleted = .one;
                }
                break;
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func skipBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "toLevelTwo", sender: self)
    }
    
    @IBAction func tutorialBtnTapped(_ sender: Any) {
        resetTutorial();
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
        self.view.accessibilityElements = [lineRef, astronaut, accessibleNumbers, nextBtn, tutorialBtn, levelBtn];
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
                  playSound()
                  holdingAstronaut = false
                  
                  if (intersectingTicks != []) {
                      let currentTick: UIView = intersectingTicks[intersectingTicks.count - 1];
                      let minXOfLine = lineRef.center.x - (lineRef.bounds.width/2)
                      astronaut.center = CGPoint(
                          x: minXOfLine + currentTick.frame.minX + 15.0,
                          y: lineRef.center.y + (lineRef.bounds.height/2) - 30.0 - astronaut.bounds.size.height / 2
                      );
                    
                    // Figuring out if they placed Tommy on the right location.
                    let lineRefBounds:CGRect = lineRef.bounds
                    let maxYOfLine = CGFloat(lineRef.center.y + (lineRefBounds.height/2))
                    let specificTick = tickLocations[0]
                    
                    if (astronaut.center.x <= specificTick.minX + minXOfLine + lineRef.lineWidth && astronaut.center.x >= specificTick.minX + minXOfLine &&
                        astronaut.center.y <= maxYOfLine && astronaut.center.y >= maxYOfLine - lineRef.lineHeight) {
                        changeInstructions(newText: "Great! Tommy has returned to the top left of the screen and now wants to reach the end of the number line. While still holding Tommy, drag him to location five. Tap the number below to check he's at the right spot!")
                        initializeNumberTexts();
                        subGoalCompleted = .one
                    }
                    
                  // Returns Tommy back to the original position.
                  } else if (holdingAstronaut == false) {
                        print("WEEEE")
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
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "splat", withExtension: "mp3") else { return }
            
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }
                
            player.play()
                
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func hasTappedLineNumber(position: CGPoint, specificNumber: Int? = -1) -> Bool {
           if (specificNumber == -1) {
               for number in lineNumberLocations {
                   if (position.x <= number.x + 30 && position.x >= number.x - 30 &&
                       position.y <= number.y + 60 && position.y >= number.y - 60) {
                       return true;
                   }
               }
           } else {
               let specificNumber = lineNumberLocations[specificNumber!]
               return (position.x <= specificNumber.x + 30 && position.x >= specificNumber.x - 30 &&
                   position.y <= specificNumber.y + 60 && position.y >= specificNumber.y - 60);
           }
           return false;
       }
    
    func hasTappedTommy(position: CGPoint) -> Bool {
        let astronautLocation = astronaut.center;
        return (position.x <= astronautLocation.x + astronaut.bounds.size.width / 2 && position.x >= astronautLocation.x - astronaut.bounds.size.width / 2 &&
            position.y <= astronautLocation.y + astronaut.bounds.size.height / 2 && position.y >= astronautLocation.y - astronaut.bounds.size.height / 2);
    }
    
    func changeInstructions(newText: String) {
        instructions.text = newText;
        instructions.accessibilityLabel = newText;
    }
    
    func resetTutorial() {
        astronaut.isHidden = true;
        instructions.text = "Tommy is lost and needs your help! We're going to place Tommy back to where he belongs. Tap the next button when you're ready!";
        stagesCompleted = .zero;
        subGoalCompleted = .zero;
    }
    
    @IBAction func unwindToLevelTwoTutorialSelector(_ sender: UIStoryboardSegue) {
        resetTutorial()
    }
}
