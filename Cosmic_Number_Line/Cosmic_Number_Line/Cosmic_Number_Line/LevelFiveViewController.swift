//
//  LevelFiveViewController.swift
//  Cosmic_Number_Line
//
//  Created by Tommy Monson on 3/24/20.
//  Copyright © 2020 Cosmic_Numbers. All rights reserved.
//
import UIKit

class LevelFiveViewController: UIViewController {

    @IBOutlet weak var title5tutorial: UILabel!
    @IBOutlet weak var step1: UILabel!
    @IBOutlet weak var step2: UILabel!
    @IBOutlet weak var step3: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityElements = [title5tutorial, step1, step2, step3, backBtn, nextBtn];
        UIAccessibility.post(notification: .screenChanged, argument: title5tutorial);
        let timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false, block: {timer in
            UIAccessibility.post(notification: .screenChanged, argument: self.step1)
            let timer1 = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: {timer1 in
                UIAccessibility.post(notification: .screenChanged, argument: self.step2)
                let timer2 = Timer.scheduledTimer(withTimeInterval: 6.5, repeats: false, block: {timer2 in
                    UIAccessibility.post(notification: .screenChanged, argument: self.step3)
                })
            })
        })
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToLevelFiveTutorialSelector(_ sender: UIStoryboardSegue) {}
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
