//
//  LevelFourGame.swift
//  Number Line
//
//  Created by Tian Liu on 12/5/19.
//  Copyright © 2019 Tian Liu. All rights reserved.
//
import UIKit
import AVFoundation

class LevelFourGame: UIViewController {
    
    
    @IBOutlet weak var lineRef: Line!
    @IBOutlet weak var astronaut: UIImageView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var questionNum: UILabel!
    @IBOutlet weak var pickerItem: UIPickerView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var astronautTwo: UIImageView!
    @IBOutlet weak var tutorial: UIButton!
    @IBOutlet weak var levels: UIButton!
    
    var desiredNumber=Int.random(in: 0...5)
    var astronautNumber=Int.random(in: 0...5)
    var accessibleNumbers:[UIView]=[]
    var selectedAnswer = "Greater than"
    var howManyLevelsAreDone:Int=0
    var previousVC:UIViewController?=nil
    var answerArray: [UIButton]=[]
    let pickerData = ["Greater than", "Equal to", "Less than"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update the question label with desired number answer
        isAccessibilityElement = true
        question.text="Is Astronaut Tommy greater than, equal to, or less than \(desiredNumber)?"
        questionNum.text="\(desiredNumber)"
        
        // update the position of the astronaut
        let linerefbounds:CGRect=lineRef.bounds
        var minXOfLine = lineRef.center.x-(linerefbounds.width/2) - 30
        astronaut.frame = CGRect(x: minXOfLine + ((linerefbounds.width-40) / 5 * CGFloat(astronautNumber)),  y: lineRef.center.y, width: astronaut.frame.size.width, height: astronaut.frame.size.height)
        
        pickerItem.dataSource = self
        pickerItem.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: Any) {
        if  (selectedAnswer == "Greater than" && astronautNumber > desiredNumber) {
            performSegue(withIdentifier: "toCongrats", sender: self)
        }
        else if (selectedAnswer == "Less than" && astronautNumber < desiredNumber){
            performSegue(withIdentifier: "toCongrats", sender: self)
        }
        else if (selectedAnswer == "Equal to" && astronautNumber == desiredNumber){
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
            tryAgainVC?.previousFourDesiredNum=desiredNumber
            tryAgainVC?.previousFourAstronautNum=astronautNumber
            tryAgainVC?.previousFour=true
        }
        else{
            // If the player answered the question correctly, he/she will play the next round
            var rightVC = segue.destination as? CorrectPopUpViewController
            if (rightVC != nil){
                rightVC!.parentFourVC=self
                rightVC!.numLevelsComplete=self.howManyLevelsAreDone
            }
            else{
                print("other vc")
            }
        }
    }
    
    // Create number labels for the number line
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
            let minXOfLine = lineRef.center.x-(linerefbounds.width/2)
            let maxYOfLine = lineRef.center.y+(linerefbounds.height/2)
            let label = UILabel(frame: CGRect(x: xDist+lineRef.offSetFromEdges + minXOfLine, y: maxYOfLine+spaceBetweenLineAndText, width: CGFloat(textWidth), height: CGFloat(textHeight)))
            
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
            i = i+1
        }
        self.view.accessibilityElements = [question, lineRef, astronaut, accessibleNumbers, astronautTwo, pickerItem, questionNum, submitBtn, tutorial, levels];
    }
}

extension LevelFourGame: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickervIEW: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        selectedAnswer = pickerData[row] as String
        print(selectedAnswer)
        print(desiredNumber)
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
