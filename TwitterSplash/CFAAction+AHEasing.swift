//
//  CFAAction+AHEasing.swift
//  Fare Weather
//
//  Created by Jamie Kosoy on 2/26/16.
//  Copyright © 2016 Arbitrary. All rights reserved.
//
//  Inspired by EasingDeclaratikons by Craig Grummitt.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//
//  Based on EasingDeclarations.h
//  AHEasing
//
//  Created by Warren Moore on 1/16/13.
//  Copyright (c) 2013 Auerhaus Development, LLC. All rights reserved.

import AHEasing
import CFAAction
import Foundation

extension CFAAction {
    private class func getEaseFunction(curve: CurveType, easeType: EaseType) -> AHEasingFunction {
        var currentFunction: AHEasingFunction

        switch(curve) {
            case .CurveTypeLinear:
                currentFunction = LinearInterpolation
            case .CurveTypeQuadratic:
                currentFunction = (easeType == .EaseTypeIn) ? QuadraticEaseIn : (easeType == .EaseTypeOut) ? QuadraticEaseOut : QuadraticEaseInOut;
            case .CurveTypeCubic:
                currentFunction = (easeType == .EaseTypeIn) ? CubicEaseIn : (easeType == .EaseTypeOut) ? CubicEaseOut : CubicEaseInOut;
            case .CurveTypeQuartic:
                currentFunction = (easeType == .EaseTypeIn) ? QuarticEaseIn : (easeType == .EaseTypeOut) ? QuarticEaseOut : QuarticEaseInOut;
            case .CurveTypeQuintic:
                currentFunction = (easeType == .EaseTypeIn) ? QuinticEaseIn : (easeType == .EaseTypeOut) ? QuinticEaseOut : QuinticEaseInOut;
            case .CurveTypeSine:
                currentFunction = (easeType == .EaseTypeIn) ? SineEaseIn : (easeType == .EaseTypeOut) ? SineEaseOut : SineEaseInOut;
            case .CurveTypeCircular:
                currentFunction = (easeType == .EaseTypeIn) ? CircularEaseIn : (easeType == .EaseTypeOut) ? CircularEaseOut : CircularEaseInOut;
            case .CurveTypeExpo:
                currentFunction = (easeType == .EaseTypeIn) ? ExponentialEaseIn : (easeType == .EaseTypeOut) ? ExponentialEaseOut : ExponentialEaseInOut;
            case .CurveTypeElastic:
                currentFunction = (easeType == .EaseTypeIn) ? ElasticEaseIn : (easeType == .EaseTypeOut) ? ElasticEaseOut : ElasticEaseInOut;
            case .CurveTypeBack:
                currentFunction = (easeType == .EaseTypeIn) ? BackEaseIn : (easeType == .EaseTypeOut) ? BackEaseOut : BackEaseInOut;
            case .CurveTypeBounce:
                currentFunction = (easeType == .EaseTypeIn) ? BounceEaseIn : (easeType == .EaseTypeOut) ? BounceEaseOut : BounceEaseInOut;
        }

        return currentFunction
    }

    class func createPointTween(start start: CGPoint, end: CGPoint, time: NSTimeInterval, easingFunction: AHEasingFunction, setterBlock setter: ((CALayer, CGPoint)->Void)) -> CFAAction {
        let action:CFAAction = CFAAction.customActionWithDuration(time, actionBlock: { (layer, elapsedTime) in
            let timeEq = easingFunction( Float(elapsedTime) / Float(time) )

            let xValue:CGFloat = start.x + CGFloat(timeEq) * (end.x - start.x)
            let yValue:CGFloat = start.y + CGFloat(timeEq) * (end.y - start.y)

            setter(layer, CGPoint(x: xValue, y: yValue) )
        })

        return action
    }
    
    class func createFloatTween(start start: CGFloat, end: CGFloat, time: NSTimeInterval, easingFunction: AHEasingFunction, setterBlock setter: ((CALayer,CGFloat)->Void)) -> CFAAction {
        let action:CFAAction = CFAAction.customActionWithDuration(time) { (layer, elapsedTime) in
            if let layer = layer {
                let timeEq = easingFunction( Float(elapsedTime) / Float(time) )
                let value: CGFloat = start + CGFloat(timeEq) * (end - start)

                setter(layer ,value)
            }
        }

        return action
    }

    // MARK: Move
    class func move(fromPoint from: CGPoint, toPoint to: CGPoint, time: NSTimeInterval, easingFunction: AHEasingFunction) -> CFAAction {
        let action = CFAAction.createPointTween(start: from, end: to, time: time, easingFunction: easingFunction) { (layer, point) in
            layer.position = point
        }
        
        return action
    }
    
    class func move(fromPoint from: CGPoint, toPoint to: CGPoint, time: NSTimeInterval, curveType curve: CurveType, easeType: EaseType) -> CFAAction {
        let easingFunction = CFAAction.getEaseFunction(curve, easeType: easeType)
        let action = CFAAction.move(fromPoint: from, toPoint: to, time: time, easingFunction: easingFunction)
        
        return action
    }
    
    // MARK: Scale
    class func scale(fromValue from:CGFloat, toValue to:CGFloat, time:NSTimeInterval, easingFunction: AHEasingFunction) -> CFAAction {
        let action = CFAAction.createFloatTween(start: from, end: to, time: time, easingFunction: easingFunction) { (layer, scale) in
            layer.setValue(scale, forKeyPath: "transform.scale.x")
            layer.setValue(scale, forKeyPath: "transform.scale.y")
        }

        return action
    }

    class func scale(fromValue from:CGFloat, toValue to:CGFloat, time:NSTimeInterval, curveType curve:CurveType, easeType:EaseType) -> CFAAction {
        let easingFunction = CFAAction.getEaseFunction(curve, easeType: easeType)
        let action = CFAAction.scale(fromValue: from, toValue: to, time: time, easingFunction: easingFunction)
        
        return action
    }
    
    // MARK: Rotate
    class func rotate(fromValue from:CGFloat, toValue to:CGFloat, time:NSTimeInterval, easingFunction: AHEasingFunction) -> CFAAction {
        let action = CFAAction.createFloatTween(start: from, end: to, time: time, easingFunction: easingFunction) { (layer, rotation) in
            layer.setValue(rotation, forKeyPath: "transform.rotation.z")
        }
        
        return action
    }
    
    class func rotate(fromValue from:CGFloat, toValue to:CGFloat, time:NSTimeInterval, curveType curve:CurveType, easeType:EaseType) -> CFAAction {
        let easingFunction = CFAAction.getEaseFunction(curve, easeType: easeType)
        let action = CFAAction.rotate(fromValue: from, toValue: to, time: time, easingFunction: easingFunction)

        return action
    }
    
    // MARK: Fade
    class func fade(fromValue from:CGFloat, toValue to:CGFloat, time:NSTimeInterval, easingFunction: AHEasingFunction) -> CFAAction {
        let action = CFAAction.createFloatTween(start: from, end: to, time: time, easingFunction: easingFunction) { (layer, alpha) in
            layer.opacity = Float(alpha)
        }
        
        return action
    }
    
    class func fade(fromValue from:CGFloat, toValue to:CGFloat, time:NSTimeInterval, curveType curve:CurveType, easeType:EaseType) -> CFAAction {
        let easingFunction = CFAAction.getEaseFunction(curve, easeType: easeType)
        let action = CFAAction.fade(fromValue: from, toValue: to, time: time, easingFunction: easingFunction)
        
        return action
    }
    
    // MARK: Background Color
    class func colorize(fromValue from:UIColor, toValue to:UIColor, time:NSTimeInterval, easingFunction: AHEasingFunction) -> CFAAction {
        var fr: CGFloat = 0;
        var fg: CGFloat = 0;
        var fb: CGFloat = 0;
        var fa: CGFloat = 0;
        
        var tr: CGFloat = 0;
        var tg: CGFloat = 0;
        var tb: CGFloat = 0;
        var ta: CGFloat = 0;

        from.getRed(&fr, green: &fg, blue: &fb, alpha: &fa)
        to.getRed(&tr, green: &tg, blue: &tb, alpha: &ta)

        let action = CFAAction.createFloatTween(start: 0, end: 1, time: time, easingFunction: easingFunction) { (layer, p) in
            let r = fr + (tr - fr) * p
            let g = fg + (tg - fg) * p
            let b = fb + (tb - fb) * p
            let a = fa + (ta - fa) * p

            let color = UIColor(red: r, green: g, blue: b, alpha: a)
            
            layer.backgroundColor = color.CGColor
        }
        
        return action
    }

/*
    class func colorizeA(fromValue from:UIColor, toValue to:UIColor, time:NSTimeInterval, easingFunction: AHEasingFunction) -> CFAAction {
        var fr: CGFloat = 0;
        var fg: CGFloat = 0;
        var fb: CGFloat = 0;
        var fa: CGFloat = 0;
        
        var fh: CGFloat = 0
        var fs: CGFloat = 0
        var fl: CGFloat = 0;
        
        var tr: CGFloat = 0;
        var tg: CGFloat = 0;
        var tb: CGFloat = 0;
        var ta: CGFloat = 0;
        
        var th: CGFloat = 0
        var ts: CGFloat = 0
        var tl: CGFloat = 0;
        
        from.getHue(&fh, saturation: &fs, brightness: &fb, alpha: &fa)
        to.getHue(&th, saturation: &ts, brightness: &tb, alpha: &ta)

        let action = CFAAction.createFloatTween(start: 0, end: 1, time: time, easingFunction: easingFunction) { (layer, p) in
            let fp = Float(p)
            
            var h = fh + (th - fh) * p
            let s = fs + (ts - fs) * p
            let b = fb + (tb - fb) * p
            let a = fa + (ta - fa) * p

            let color = UIColor(hue: h, saturation: s, brightness: b, alpha: a)

            layer.backgroundColor = color.CGColor
        }
        
        return action
    }

    class func colorizeB(fromValue from:UIColor, toValue to:UIColor, time:NSTimeInterval, easingFunction: AHEasingFunction) -> CFAAction {
        var fr: CGFloat = 0;
        var fg: CGFloat = 0;
        var fb: CGFloat = 0;
        var fa: CGFloat = 0;

        var fh: Float = 0
        var fs: Float = 0
        var fl: Float = 0;

        var tr: CGFloat = 0;
        var tg: CGFloat = 0;
        var tb: CGFloat = 0;
        var ta: CGFloat = 0;

        var th: Float = 0
        var ts: Float = 0
        var tl: Float = 0;

        from.getRed(&fr, green: &fg, blue: &fb, alpha: &fa)
        to.getRed(&tr, green: &tg, blue: &tb, alpha: &ta)

        RGB2HSL(Float(fr) * 255, Float(fg) * 255, Float(fb) * 255, &fh, &fs, &fl)
        RGB2HSL(Float(tr) * 255, Float(tg) * 255, Float(tb) * 255, &th, &ts, &tl)

        print("From RGB ::", fr, fg, fb, fa)
        print("From HSL ::", fh, fs, fl, fa)

        print("To RGB ::", tr, tb, tg, ta)
        print("To HSL ::", th, ts, tl, ta)

        let action = CFAAction.createFloatTween(start: 0, end: 1, time: time, easingFunction: easingFunction) { (layer, p) in
            let fp = Float(p)
            
            var h = fh + (th - fh) * fp
            let s = fs + (ts - fs) * fp
            let l = fl + (tl - fl) * fp
            let a = fa + (ta - fa) * p
            
//            let h = fh * (1 - fp) + th * fp;
//            let s = fs * (1 - fp) + ts * fp;
//            let l = fl * (1 - fp) + tl * fp;
//            let a = fa * (1 - p) + ta * p;

            var r: Float = 0
            var g: Float = 0
            var b: Float = 0

            HSL2RGB(h, s, l, &r, &g, &b)

            print(r, g, b, a, p)

            let color = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: a)
            layer.backgroundColor = color.CGColor
        }
        
        return action
    }
*/

    class func colorize(fromValue from:UIColor, toValue to:UIColor, time:NSTimeInterval, curveType curve:CurveType, easeType:EaseType) -> CFAAction {
        let easingFunction = CFAAction.getEaseFunction(curve, easeType: easeType)
        let action = CFAAction.colorize(fromValue: from, toValue: to, time: time, easingFunction: easingFunction)
        
        return action
    }
}