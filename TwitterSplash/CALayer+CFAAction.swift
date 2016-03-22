//
//  CALayer+CFAAction.swift
//  Fare Weather
//
//  Created by Jamie Kosoy on 2/26/16.
//  Copyright © 2016 Arbitrary. All rights reserved.
//

import UIKit
import CFAAction

extension CALayer {
    func runAction(action: CFAAction!) {
        self.cfa_runAction(action)
    }
    
    func runAction(action: CFAAction!, completion: (() -> Void)!) {
        self.cfa_runAction(action, completion: completion)
    }
}