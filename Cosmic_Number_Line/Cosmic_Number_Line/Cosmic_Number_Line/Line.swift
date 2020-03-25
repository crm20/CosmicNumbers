//
//  Line.swift
//  Number Line
//
//  Created by Tian Liu on 2/21/19.
//  Copyright © 2019 Tian Liu. All rights reserved.
//

import UIKit

class Line: UIView {
    var line = UIBezierPath()
    var points = [UIBezierPath]()
    let offSetFromEdges:CGFloat=10.0
    let numberOfPoints=5
    let lineHeight:CGFloat = 100.0
    let lineWidth:CGFloat = 30.0
    var baseOfLine:CGFloat = 0.0
    var distance:CGFloat = 0.0
    var myOffset:String = ""
    var backgroundView:LineBackgroundView? = nil
    var accessibleTicks:[TickView] = []
    
    // Draw out the number line
    override func draw(_ rec: CGRect) {
        // [baseOfLine] refers to the y coordinate of where the number line will be drawn from.
        baseOfLine = self.bounds.maxY-(lineWidth/2)
        
        // [distance] refers to the distance between each tick mark on the number line.
        distance = (self.bounds.maxX-self.bounds.minX-(2*offSetFromEdges)-(lineWidth)) / CGFloat(numberOfPoints)
        
        // Calls a function that creates the number line.
        graph()
    }
    
    func returnMyOffset()->CGFloat{
        return self.bounds.minX
    }
    
    // Function that creates the number line. Called in the draw function above.
    func graph() {
        // Moving to the starting point to draw from.
        line.move(to: CGPoint(x: self.bounds.minX+offSetFromEdges, y: baseOfLine))
        
        // Drawing the horizontal line that represents the number line.
        line.addLine(to: CGPoint(x: self.bounds.maxX-offSetFromEdges, y: baseOfLine))
        
        // Setting the stroke (border) width and its color to white for better definition and stroking.
        line.lineWidth = lineWidth
        UIColor.white.setStroke()
        line.stroke()
        
        // Creating the background of the line via a CGRect.
        backgroundView = LineBackgroundView(frame:
            CGRect(
                x:self.bounds.minX,
                y:self.bounds.minY,width:self.bounds.maxX-self.bounds.minX,
                height:self.bounds.maxY-self.bounds.minY
            )
        )
        
        // Setting the background view's line, offset, and making it an accessibility element.
        backgroundView!.line = self
        self.myOffset=self.bounds.minX.description
        backgroundView!.isAccessibilityElement = true
        backgroundView!.accessibilityLabel = ""

        // The line is on a subview, so we need to add this subview on the screen.
        self.addSubview(backgroundView!)
        
        // Creating the tick marks for the number line.
        // Note, it currently goes to 5 due to hard coding, but could change in the future.
        for i in 0...5 {
            // Appending a new vertical line to the vertical line array.
            points.append(UIBezierPath())
            
            // Distance between each vertical line on the number line.
            let xdist = distance*CGFloat(i) + offSetFromEdges
            
            // Moving to the starting point to draw from.
            points[i].move(to: .init(x: xdist+(0.5*lineWidth), y: baseOfLine))
            
            // Drawing the vertical line that represents the tick mark on the number line.
            points[i].addLine(to: .init(x: xdist+(0.5*lineWidth), y: baseOfLine-lineHeight))
            
            // Setting width and coloring the line.
            UIColor.white.setStroke()
            points[i].lineWidth = lineWidth
            points[i].stroke()
            
            // Making the line an accessibility element.
            points[i].isAccessibilityElement = true
            points[i].accessibilityTraits = UIAccessibilityTraits.playsSound
            points[i].accessibilityLabel = String(i)
            
            // Creating the accessibility tick that resides on the vertical line.
            var myUIView:TickView = TickView(frame:
                CGRect(
                    x:xdist+(0.5*lineWidth)-(lineWidth/2),
                    y:baseOfLine-lineHeight,width:lineWidth,
                    height:lineHeight+(0.5*lineWidth)
                )
            )
            myUIView.isAccessibilityElement=true
            myUIView.accessibilityLabel="tick"
            accessibleTicks.append(myUIView)
            
            // Making the ticks visible.
            self.addSubview(myUIView)
            self.bringSubviewToFront(myUIView)
        }
        
        // Not entirely sure.
        if let parentVC = self.parentViewController {
            if let parentVC = parentVC as? LevelOneGame {
                (self.parentViewController as! LevelOneGame).initializeNumberTexts()
            } else if let parentVC = parentVC as? LevelTwoGame {
                (self.parentViewController as! LevelTwoGame).initializeNumberTexts()
            } else if let parentVC = parentVC as? LevelThreeGame {
                (self.parentViewController as! LevelThreeGame).initializeNumberTexts()
            }  else if let parentVC = parentVC as? LevelFourGame {
                (self.parentViewController as! LevelFourGame).initializeNumberTexts()
            }
        }
    }
    
    // Make tick marks accessible
    func reenableAllTicks() {
        for tick in accessibleTicks{
            tick.isAccessibilityElement=true
        }
    }
}

// Not entirely sure.
extension UIView{
    var parentViewController:UIViewController?{
        var parentResponder:UIResponder?=self
        while parentResponder != nil {
            parentResponder=parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            
        }
        return nil
    }
}
