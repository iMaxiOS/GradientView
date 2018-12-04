//
//  ViewController.swift
//  GradientView
//
//  Created by Гранченко Максим on 12/4/18.
//  Copyright © 2018 Гранченко Максим. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {

    var gradient: CAGradientLayer!
    var colorRation: ColorRation!
    var color = [[CGColor]]()
    var colorSet: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createColorSet()
        createGradientView()
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer))
//        gestureRecognizer.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(gestureRecognizer)
    
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.backgroundColor = .black
        self.gradient.frame = self.view.frame
        
    }
    
    @objc func handlePanGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer) {
        let velocity = gestureRecognizer.velocity(in: self.view)
        
        if gestureRecognizer.state == UIGestureRecognizer.State.changed {
            if velocity.x > 300.0 {
                if velocity.y > 300.0 {
                    // Movement from Top-Left to Bottom-Right.
                    colorRation = ColorRation.TopLeftToBottomRight
                }
                else if velocity.y < -300.0 {
                    // Movement from Bottom-Left to Top-Right.
                    colorRation = ColorRation.BottomLeftToTopRight
                }
                else {
                    // Movement towards Right.
                    colorRation = ColorRation.Right
                }
            }
            else if velocity.x < -300.0 {
                // In this case the direction is generally towards Left.
                // Below are specific cases regarding the vertical movement of the gesture.
                
                if velocity.y > 300.0 {
                    // Movement from Top-Right to Bottom-Left.
                    colorRation = ColorRation.TopRightToBottomLeft
                }
                else if velocity.y < -300.0 {
                    // Movement from Bottom-Right to Top-Left.
                    colorRation = ColorRation.BottomRightToTopLeft
                }
                else {
                    // Movement towards Left.
                    colorRation = ColorRation.Left
                }
            }
            else {
                // In this case the movement is mostly vertical (towards bottom or top).
                
                if velocity.y > 300.0 {
                    // Movement towards Bottom.
                    colorRation = ColorRation.Bottom
                }
                else if velocity.y < -300.0 {
                    // Movement towards Top.
                    colorRation = ColorRation.Top
                }
                else {
                    // Do nothing.
                    colorRation = nil
                }
            }
        }
        else if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            changeGradientDirection()
        }
    }
    
    func changeGradientDirection() {
        if colorRation != nil {
            switch colorRation.rawValue {
            case ColorRation.Right.rawValue:
                gradient.startPoint = CGPoint(x:0.0, y:0.5)
                gradient.endPoint = CGPoint(x:1.0, y:0.5)
                
            case ColorRation.Left.rawValue:
                gradient.startPoint = CGPoint(x:1.0, y:0.5)
                gradient.endPoint = CGPoint(x:0.0, y:0.5)
                
            case ColorRation.Bottom.rawValue:
                gradient.startPoint = CGPoint(x:0.5, y:0.0)
                gradient.endPoint = CGPoint(x:0.5, y:1.0)
                
            case ColorRation.Top.rawValue:
                gradient.startPoint = CGPoint(x:0.5, y:1.0)
                gradient.endPoint = CGPoint(x:0.5, y:0.0)
                
            case ColorRation.TopLeftToBottomRight.rawValue:
                gradient.startPoint = CGPoint(x:0.0, y:0.0)
                gradient.endPoint = CGPoint(x:1.0, y:1.0)
                
            case ColorRation.TopRightToBottomLeft.rawValue:
                gradient.startPoint = CGPoint(x:1.0, y:0.0)
                gradient.endPoint = CGPoint(x:0.0, y:1.0)
                
            case ColorRation.BottomLeftToTopRight.rawValue:
                gradient.startPoint = CGPoint(x:0.0, y:1.0)
                gradient.endPoint = CGPoint(x:1.0, y:0.0)
                
            default:
                gradient.startPoint = CGPoint(x:1.0, y:1.0)
                gradient.endPoint = CGPoint(x:0.0, y:0.0)
            }
        }
    }
    
    @objc func twoHandlerTapGestureRecognizer(gesture: UITapGestureRecognizer) {
        let secondColorLocation = arc4random_uniform(100)
        let firstColorLocation = arc4random_uniform(secondColorLocation - 1)
        
        gradient.locations = [NSNumber(value: Double(firstColorLocation)/100.0), NSNumber(value: Double(secondColorLocation)/100.0)]
        
        print(gradient.locations!)
    }
    
    @objc func handlerTapGestureRecognizer(gesture: UITapGestureRecognizer) {
        if colorSet < color.count - 1 {
            colorSet += 1
        } else {
            colorSet = 0
        }
        
        let colorChangeAnimation = CABasicAnimation(keyPath: "colors")
        colorChangeAnimation.duration = 2.0
        colorChangeAnimation.byValue = color[colorSet]
        colorChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        colorChangeAnimation.isRemovedOnCompletion = false
        colorChangeAnimation.delegate = self
        gradient.add(colorChangeAnimation, forKey: "colorChange")
    }
    
//    private func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if flag {
//            gradient.colors = color[colorSet]
//        }
//    }

    func createGradientView() {
        gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = self.view.frame
        gradient.colors = color[colorSet]
//        gradient.locations = [0.2, 0.35]
        self.view.layer.addSublayer(gradient)
    }
    
    func createColorSet() {
        color.append([UIColor.red.cgColor, UIColor.magenta.cgColor, UIColor.blue.cgColor])
        color.append([UIColor.orange.cgColor, UIColor.black.cgColor, UIColor.white.cgColor])
        color.append([UIColor.yellow.cgColor, UIColor.lightGray.cgColor, UIColor.cyan.cgColor])
        
        colorSet = 0
    }
    
    

}

