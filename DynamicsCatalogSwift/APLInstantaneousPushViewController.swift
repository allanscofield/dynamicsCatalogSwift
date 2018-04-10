//
//  APLInstantaneousPushViewController.swift
//  DynamicsCatalogSwift
//
//  Created by Allan on 10/04/2018.
//  Copyright © 2018 Allan Pacheco. All rights reserved.
//

import UIKit

class APLInstantaneousPushViewController: UIViewController {

    @IBOutlet weak var square1: UIView!
    
    var animator: UIDynamicAnimator!
    var pushBehavior: UIPushBehavior!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animator = UIDynamicAnimator(referenceView: self.view)
        
        let collisionBehavior = UICollisionBehavior(items: [self.square1])
        // Account for any top and bottom bars when setting up the reference bounds.
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0, bottom: self.view.safeAreaInsets.bottom, right: 0))
        animator.addBehavior(collisionBehavior)
        
        pushBehavior = UIPushBehavior(items: [self.square1], mode: .instantaneous)
        pushBehavior.angle = 0
        pushBehavior.magnitude = 0
        animator.addBehavior(pushBehavior)
        
    }
    
    @IBAction func handlePushGesture(_ sender: UITapGestureRecognizer) {
        
        // Tapping will change the angle and magnitude of the impulse. To visually
        // show the impulse vector on screen, a red arrow representing the angle
        // and magnitude of this vector is briefly drawn.
        let p = sender.location(in: self.view)
        let o = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        var distance = CGFloat(sqrtf(powf(Float(p.x - o.x), 2.0) + powf(Float(p.y - o.y), 2.0)))
        let angle = CGFloat(atan2(p.y - o.y, p.x - o.x))
        distance = min(distance, 100.0)
        
        // Display an arrow showing the direction and magnitude of the applied impulse.
        (self.view as! APLDecorationView).drawMagnitudeVectorWithLength(distance, angle: angle, color: UIColor.red, forLimitedTime: true)
        
        // These two lines change the actual force vector.
        pushBehavior.magnitude = distance / 100.0
        pushBehavior.angle = angle
        
        // A push behavior in instantaneous (impulse) mode automatically
        // deactivate itself after applying the impulse. We thus need to reactivate
        // it when changing the impulse vector.
        pushBehavior.active = true
    }
    

}
