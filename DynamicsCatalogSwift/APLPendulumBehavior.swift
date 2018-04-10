//
//  APLPendulumBehavior.swift
//  DynamicsCatalogSwift
//
//  Created by Allan on 10/04/2018.
//  Copyright © 2018 Allan Pacheco. All rights reserved.
//

import UIKit

class APLPendulumBehavior: UIDynamicBehavior {
    
    var draggingBehavior: UIAttachmentBehavior!
    var pushBehavior: UIPushBehavior!
    
    convenience init(withWeigh item: UIDynamicItem, suspendedFromPoint p: CGPoint) {
        self.init()
        
        // The high-level pendulum behavior is built from 2 primitive behaviors.
        let gravityBehavior = UIGravityBehavior(items: [item])
        let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: p)
        
        // These primative behaviors allow the user to drag the pendulum weight
        draggingBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: CGPoint.zero)
        pushBehavior = UIPushBehavior(items: [item], mode: .instantaneous)
        pushBehavior.active = false
        
        self.addChildBehavior(gravityBehavior)
        self.addChildBehavior(attachmentBehavior)
        self.addChildBehavior(pushBehavior)
        
        // The draggingBehavior is added as needed, when the user begins dragging the weight.
    }
    
    func beginDraggingWeightAtPoint(p: CGPoint){
        self.draggingBehavior.anchorPoint = p
        self.addChildBehavior(draggingBehavior)
    }
    
    func dragWeightToPoint(p: CGPoint){
        self.draggingBehavior.anchorPoint = p
    }
    
    func endDraggingWeightWithVelocity(v: CGPoint){
        
        var magnitude = CGFloat(sqrtf(powf(Float(v.x), 2.0) + powf(Float(v.y), 2.0)))
        let angle = CGFloat(atan2(Float(v.y), Float(v.x)))
        
        // Reduce the volocity to something meaningful.  (Prevents the user from flinging the pendulum weight).
        magnitude /= 500
        
        self.pushBehavior.angle = angle
        self.pushBehavior.magnitude = magnitude
        self.pushBehavior.active = true
        
        self.removeChildBehavior(self.draggingBehavior)
    }
    
}
