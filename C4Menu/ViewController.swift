//
//  ViewController.swift
//  C4Menu
//
//  Created by travis on 2015-02-01.
//  Copyright (c) 2015 C4. All rights reserved.
//

import UIKit
import C4Core
import C4UI
import C4Animation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        canvas.backgroundColor = lightGray
        createMenu()
        createLogo()
        createAnimations()
    }

    var buttons = [MenuButton]()
    var tapView = C4View()
    var menu = C4View()
    func createMenu() {
        let menuHeight = 211.0
        let screenSize = C4Size(view.frame.size)
        let menuFrame = C4Rect(0.0,screenSize.height - menuHeight, screenSize.width, menuHeight)
        menu = C4View(frame: menuFrame)
        menu.backgroundColor = white
        
        var about = MenuButton("News")
        about.action = {
            println("-> news")
            self.toggleMenu()
        }
        
        var components = MenuButton("Story")
        components.action = {
            println("-> story")
            self.toggleMenu()
        }
        
        var tutorials = MenuButton("Components")
        tutorials.action = {
            println("-> components")
            self.toggleMenu()
        }
        
        var examples = MenuButton("Examples")
        examples.action = {
            println("-> other")
            self.toggleMenu()
        }
        
        var origin = C4Point(menu.width - 20 - components.width, 20)
        var buttonSize = components.size
        let gap = 9.0
        let dy = buttonSize.height + gap
        components.origin = origin
        origin.y += dy
        tutorials.origin = origin
        origin.y += dy
        examples.origin = origin
        origin.y += dy
        about.origin = origin
        
        menu.add(components)
        menu.add(tutorials)
        menu.add(examples)
        menu.add(about)
        
        buttons.append(components)
        buttons.append(tutorials)
        buttons.append(examples)
        buttons.append(about)
        
        view.add(menu)
    }

    var menuAnimation = C4ViewAnimation(){}
    var tapViewAnimation = C4ViewAnimation(){}
    var buttonAnimations = [C4ViewAnimation]()
    var cAnimation = C4ViewAnimation(){}
    var fAnimation = C4ViewAnimation(){}
    let dy = 118.0
    var isUp = true
    var up = C4ViewAnimation(){}
    var down = C4ViewAnimation(){}
    
    func createAnimations() {
        tapView = C4View(frame: C4Rect(0,Double(view.frame.size.height)-204,100,86))
        view.add(tapView)
        
        menuAnimation = C4ViewAnimation(duration: 0.25) {
            let y = self.isUp ? Double(self.view.frame.size.height) : Double(self.view.frame.size.height)-self.menu.height
            self.menu.origin = C4Point(0,y)
        }
        menuAnimation.curve = .EaseOut
        
        for i in 0...3 {
            var anim = C4ViewAnimation(duration: 0.25) {
                let dy = self.isUp ? self.dy : -self.dy
                var origin = self.buttons[i].origin
                origin.y += dy
                self.buttons[i].origin = origin
            }
            anim.curve = .EaseOut
            buttonAnimations.append(anim)
        }
        
        tapViewAnimation = C4ViewAnimation(duration: 0.25) {
            let dy = self.isUp ? self.dy : -self.dy
            self.tapView.origin = C4Point(self.tapView.origin.x,self.tapView.origin.y + dy)
        }
        
        cAnimation = C4ViewAnimation(duration: 0.25) {
            let dy = self.isUp ? self.dy : -self.dy
            self.c.origin = C4Point(self.c.origin.x,self.c.origin.y + dy)
            self.fmask.origin = C4Point(self.fmask.origin.x,self.fmask.origin.y + dy)
        }
        cAnimation.curve = .EaseOut
        
        fAnimation = C4ViewAnimation(duration: 0.25) {
            let dy = self.isUp ? self.dy : -self.dy
            self.f.origin = C4Point(self.f.origin.x,self.f.origin.y + dy)
            self.f2.origin = C4Point(self.f2.origin.x,self.f2.origin.y + dy)
            self.fmask.origin = C4Point(self.fmask.origin.x,self.fmask.origin.y - dy)
        }
        fAnimation.curve = .EaseOut
        
        
        tapView.addTapGestureRecognizer { (location, state) -> () in
            self.toggleMenu()
        }
    }

    func toggleMenu() {
        self.isUp = self.menu.origin.y < Double(self.view.frame.size.height) ? true : false
        
        delay(0.1) {
            self.menuAnimation.animate()
        }
        
        if(self.isUp) {
            self.buttonAnimations[3].animate()
            delay(0.05) {
                self.buttonAnimations[2].animate()
            }
            delay(0.1) {
                self.buttonAnimations[1].animate()
            }
            delay(0.15) {
                self.buttonAnimations[0].animate()
            }
        } else {
            self.buttonAnimations[0].animate()
            delay(0.05) {
                self.buttonAnimations[1].animate()
            }
            delay(0.1) {
                self.buttonAnimations[2].animate()
            }
            delay(0.15) {
                self.buttonAnimations[3].animate()
            }
        }
        
        self.tapViewAnimation.animate()
        self.cAnimation.animate()
        
        delay(0.1) {
            self.fAnimation.animate()
        }
    }
    
    var c = C4Shape()
    var f = C4Shape()
    var f2 = C4Shape()
    var fmask = C4Shape()
    
    func createLogo() {
        var t = C4Transform.makeScale(4.0, 4.0, 0.0)
        
        var cp = C4Path()
        
        cp.moveToPoint(C4Point(12.5, 10))
        cp.addLineToPoint(C4Point(7.5, 10))
        cp.addCurveToPoint(C4Point(6.12, 10), control2: C4Point(5, 8.88), point: C4Point(5, 7.5))
        cp.addCurveToPoint(C4Point(5, 6.12), control2: C4Point(6.12, 5), point: C4Point(7.5, 5))
        cp.addLineToPoint(C4Point(12.5, 5))
        cp.addCurveToPoint(C4Point(13.88, 5), control2: C4Point(15, 3.88), point: C4Point(15, 2.5))
        cp.addCurveToPoint(C4Point(15, 1.12), control2: C4Point(13.88, 0), point: C4Point(12.5, 0))
        cp.addLineToPoint(C4Point(7.5, 0))
        cp.addCurveToPoint(C4Point(3.36, 0), control2: C4Point(0, 3.36), point: C4Point(0, 7.5))
        cp.addCurveToPoint(C4Point(0, 11.64), control2: C4Point(3.36, 15), point: C4Point(7.5, 15))
        cp.addLineToPoint(C4Point(12.5, 15))
        cp.addCurveToPoint(C4Point(13.88, 15), control2: C4Point(15, 13.88), point: C4Point(15, 12.5))
        cp.addCurveToPoint(C4Point(15, 11.12), control2: C4Point(13.88, 10), point: C4Point(12.5, 10))
        cp.closeSubpath()
        cp.transform(t)
        
        c = C4Shape(cp)
        c.fillColor = C4Pink
        c.origin = C4Point(20.0, menu.origin.y + 20.0)
        c.interactionEnabled = false
        
        var fp = C4Path()
        fp.moveToPoint(C4Point(17.5, 5))
        fp.addLineToPoint(C4Point(15, 5))
        fp.addLineToPoint(C4Point(15, 2.5))
        fp.addCurveToPoint(C4Point(15, 1.12), control2: C4Point(13.88, 0), point: C4Point(12.5, 0))
        fp.addCurveToPoint(C4Point(11.81, 0), control2: C4Point(11.18, 0.28), point: C4Point(10.73, 0.73))
        fp.addLineToPoint(C4Point(5.74, 5.72))
        fp.addLineToPoint(C4Point(5.74, 5.72))
        fp.addCurveToPoint(C4Point(5.28, 6.18), control2: C4Point(5, 6.81), point: C4Point(5, 7.5))
        fp.addCurveToPoint(C4Point(5, 8.88), control2: C4Point(6.12, 10), point: C4Point(7.5, 10))
        fp.addLineToPoint(C4Point(10, 10))
        fp.addLineToPoint(C4Point(10, 12.5))
        fp.addCurveToPoint(C4Point(10, 13.88), control2: C4Point(11.12, 15), point: C4Point(12.5, 15))
        fp.addCurveToPoint(C4Point(13.88, 15), control2: C4Point(15, 13.88), point: C4Point(15, 12.5))
        fp.addLineToPoint(C4Point(15, 10))
        fp.addLineToPoint(C4Point(17.5, 10))
        fp.addCurveToPoint(C4Point(18.88, 10), control2: C4Point(20, 8.88), point: C4Point(20, 7.5))
        fp.addCurveToPoint(C4Point(20, 6.12), control2: C4Point(18.88, 5), point: C4Point(17.5, 5))
        fp.closeSubpath()
        fp.transform(t)
        
        f = C4Shape(fp)
        f.fillColor = C4Blue
        f.origin = C4Point(f.origin.x+20, c.origin.y)
        f.interactionEnabled = false
        f.interactionEnabled = false;
        
        f2 = C4Shape(fp)
        f2.fillColor = C4Purple
        f2.origin = f.origin
        f2.interactionEnabled = false
        
        fmask = C4Shape(cp)
        fmask.origin = C4Point(c.origin.x - f.origin.x, 0)
        fmask.lineWidth = 1.0
        f2.layer?.mask = fmask.layer
        
        view.add(c)
        view.add(f)
        view.add(f2)
    }
}

