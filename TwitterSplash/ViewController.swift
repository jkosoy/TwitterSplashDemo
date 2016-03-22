//
//  ViewController.swift
//  TwitterSplash
//
//  Created by Jamie Kosoy on 3/19/16.
//  Copyright © 2016 Arbitrary. All rights reserved.
//

import UIKit
import CFAAction

class ViewController: UIViewController {
    let twitterBlue = UIColor(red: 0.114, green: 0.631, blue: 0.949, alpha: 1)
    var isAppIn = false
    
    let maskLayer = CAShapeLayer() // the bird being used as a mask to reveal the app. we'll animate this bigger and smaller.
    let birdLayer = CAShapeLayer() // a copy of the bird, but this time as a solid white color. we'll animate this bigger and smaller as well.
    
    let startScale: CGFloat = 58.0 / 1220.0 // I exported the Twitter logo at 1220px wide, then measured the actual logo from a screenshot I took of the app.
    
    let appView = UIView() // will contain a screenshot of Twitter
    let birdView = UIView() // a blue screen with the white Twitter bird
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = twitterBlue
        
        let screenshot = UIImage(named: "Screenshot.png")
        let imageView = UIImageView(image: screenshot)
        imageView.frame = view.frame // my lazy way to resize the screenshot for this demo. it's build for iPhone 6.

        appView.frame = view.frame
        appView.addSubview(imageView)

        let twitterBirdPath = twitterBird().CGPath // get the logo as a shape.

        // create a mask layer out of the twitter bird
        maskLayer.path = twitterBirdPath
        maskLayer.position = view.center
        maskLayer.setValue(startScale, forKeyPath: "transform.scale.x")
        maskLayer.setValue(startScale, forKeyPath: "transform.scale.y")
        appView.layer.mask = maskLayer // set the mask layer as a mask of the app view

        // now using the same path create the white bird to put in the birdView
        birdLayer.path = twitterBirdPath
        birdLayer.position = view.center
        birdLayer.setValue(startScale, forKeyPath: "transform.scale.x")
        birdLayer.setValue(startScale, forKeyPath: "transform.scale.y")
        birdLayer.fillColor = UIColor.whiteColor().CGColor

        birdView.frame = view.frame
        birdView.layer.addSublayer(birdLayer) // add the bird layer to the bird view.

        // add to our screen
        view.addSubview(appView)
        view.addSubview(birdView)
    }
    
    func toggleReveal() {
        isAppIn = !isAppIn

        if(isAppIn) {
            animateAppIn()
        }
        else {
            animateAppOut()
        }
    }

    func animateAppIn() {
        // I don't have a good easing equation to match Twitter, so what I do is scale the logo down slowly (over 0.25 seconds)...
        let scalePt1 = CFAAction.scale(fromValue: startScale, toValue: startScale * 0.33, time: 0.25, curveType: CurveType.CurveTypeLinear, easeType: EaseType.EaseTypeIn)

        // then boost it up to 250% its normal scale from there over 0.13 seconds.
        let scalePt2 = CFAAction.scale(fromValue: startScale * 0.33, toValue: 2.5, time: 0.13, curveType: CurveType.CurveTypeLinear, easeType: EaseType.EaseTypeOut)

        // I can do this for both the mask and the white bird simply by creating two "sequences".
        birdLayer.runAction(CFAAction.sequence([ scalePt1, scalePt2 ]))
        maskLayer.runAction(CFAAction.sequence([ scalePt1, scalePt2 ]))
        // the sequence will run scalePt1, then scalePt2.
        
        // to finish the effect after a third of a second I hide the view containing the white bird.
        // since the mask is moving at the same speed underneath of it the transition looks seamless and you see the app behind it.
        birdView.hidden = false
        view.layer.runAction(CFAAction.waitForDuration(0.33)) {
            self.birdView.hidden = true
        }
    }
    
    // this more or less reverses the animateAppIn code, so you can tap to see play it back and forth.
    func animateAppOut() {
        let scalePt1 = CFAAction.scale(fromValue: 2.5, toValue: startScale * 0.33, time: 0.25, curveType: CurveType.CurveTypeLinear, easeType: EaseType.EaseTypeIn)
        let scalePt2 = CFAAction.scale(fromValue: startScale * 0.33, toValue: startScale, time: 0.15, curveType: CurveType.CurveTypeLinear, easeType: EaseType.EaseTypeOut)

        birdView.hidden = true

        
        birdLayer.runAction(CFAAction.sequence([ scalePt1, scalePt2 ]))
        maskLayer.runAction(CFAAction.sequence([ scalePt1, scalePt2 ]))
        
        view.layer.runAction(CFAAction.waitForDuration(0.5)) {
            self.birdView.hidden = false
        }
        
    }
    
    func twitterBird() -> UIBezierPath {
        // I used PaintCode to generate the Twitter logo.
        // http://www.paintcodeapp.com/
        // https://en.wikipedia.org/wiki/File:Twitter_bird_logo_2012.svg

        // I opened the logo in Sketch and exported it out at 1220x1000. I can use those numbers to scale the bird later on.
        // In PaintCode I set the origin to the center of the logo, just to make my life easier.

        let fillColor = UIColor.blackColor()

        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(607.99, -376.97))
        bezierPath.addCurveToPoint(CGPointMake(464.84, -337.7), controlPoint1: CGPointMake(563.31, -357.14), controlPoint2: CGPointMake(515.26, -343.74))
        bezierPath.addCurveToPoint(CGPointMake(574.42, -475.61), controlPoint1: CGPointMake(516.3, -368.56), controlPoint2: CGPointMake(555.81, -417.41))
        bezierPath.addCurveToPoint(CGPointMake(416.12, -415.13), controlPoint1: CGPointMake(526.26, -447.03), controlPoint2: CGPointMake(472.93, -426.3))
        bezierPath.addCurveToPoint(CGPointMake(234.19, -493.84), controlPoint1: CGPointMake(370.67, -463.56), controlPoint2: CGPointMake(305.88, -493.84))
        bezierPath.addCurveToPoint(CGPointMake(-15.08, -244.57), controlPoint1: CGPointMake(96.51, -493.84), controlPoint2: CGPointMake(-15.08, -382.24))
        bezierPath.addCurveToPoint(CGPointMake(-8.63, -187.76), controlPoint1: CGPointMake(-15.08, -225.03), controlPoint2: CGPointMake(-12.89, -206))
        bezierPath.addCurveToPoint(CGPointMake(-522.43, -448.21), controlPoint1: CGPointMake(-215.8, -198.15), controlPoint2: CGPointMake(-399.48, -297.42))
        bezierPath.addCurveToPoint(CGPointMake(-556.18, -322.91), controlPoint1: CGPointMake(-543.88, -411.41), controlPoint2: CGPointMake(-556.18, -368.6))
        bezierPath.addCurveToPoint(CGPointMake(-445.28, -115.41), controlPoint1: CGPointMake(-556.18, -236.41), controlPoint2: CGPointMake(-512.19, -160.13))
        bezierPath.addCurveToPoint(CGPointMake(-558.19, -146.59), controlPoint1: CGPointMake(-486.14, -116.69), controlPoint2: CGPointMake(-524.58, -127.91))
        bezierPath.addCurveToPoint(CGPointMake(-558.23, -143.46), controlPoint1: CGPointMake(-558.23, -145.54), controlPoint2: CGPointMake(-558.23, -144.5))
        bezierPath.addCurveToPoint(CGPointMake(-358.27, 100.98), controlPoint1: CGPointMake(-558.23, -22.67), controlPoint2: CGPointMake(-472.3, 78.06))
        bezierPath.addCurveToPoint(CGPointMake(-423.92, 109.69), controlPoint1: CGPointMake(-379.17, 106.67), controlPoint2: CGPointMake(-401.19, 109.69))
        bezierPath.addCurveToPoint(CGPointMake(-470.84, 105.24), controlPoint1: CGPointMake(-440, 109.69), controlPoint2: CGPointMake(-455.59, 108.17))
        bezierPath.addCurveToPoint(CGPointMake(-237.96, 278.37), controlPoint1: CGPointMake(-439.1, 204.27), controlPoint2: CGPointMake(-347.06, 276.35))
        bezierPath.addCurveToPoint(CGPointMake(-547.6, 385.07), controlPoint1: CGPointMake(-323.34, 345.24), controlPoint2: CGPointMake(-430.8, 385.07))
        bezierPath.addCurveToPoint(CGPointMake(-607.08, 381.59), controlPoint1: CGPointMake(-567.71, 385.07), controlPoint2: CGPointMake(-587.57, 383.88))
        bezierPath.addCurveToPoint(CGPointMake(-224.92, 493.57), controlPoint1: CGPointMake(-496.72, 452.32), controlPoint2: CGPointMake(-365.71, 493.57))
        bezierPath.addCurveToPoint(CGPointMake(484.27, -215.68), controlPoint1: CGPointMake(233.57, 493.57), controlPoint2: CGPointMake(484.27, 113.75))
        bezierPath.addCurveToPoint(CGPointMake(483.57, -247.9), controlPoint1: CGPointMake(484.27, -226.48), controlPoint2: CGPointMake(484.02, -237.21))
        bezierPath.addCurveToPoint(CGPointMake(607.94, -376.97), controlPoint1: CGPointMake(532.25, -283.08), controlPoint2: CGPointMake(574.51, -326.97))
        bezierPath.miterLimit = 4;
        
        bezierPath.usesEvenOddFillRule = true;
        
        fillColor.setFill()
        bezierPath.fill()
        
        return bezierPath
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        toggleReveal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

