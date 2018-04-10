//
//  APLContinuousPushViewController.swift
//  DynamicsCatalogSwift
//
//  Created by Allan on 10/04/2018.
//  Copyright © 2018 Allan Pacheco. All rights reserved.
//

import UIKit

class APLContinuousPushViewController: UIViewController {

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
        
        pushBehavior = UIPushBehavior(items: [self.square1], mode: .continuous)
        pushBehavior.angle = 0
        pushBehavior.magnitude = 0
        animator.addBehavior(pushBehavior)
    }

    @IBAction func handlePushContinousGesture(_ sender: UITapGestureRecognizer) {
        
        // Tapping in the view changes the angle and magnitude of the force. To
        // visually show the force vector on screen, a red arrow is drawn
        // representing the angle and magnitude of this vector. The force is
        // continuously applied while the behavior is active, so we keep the vector
        // line visible and just update its size and rotation to represent the
        // vector.
        
        let p = sender.location(in: self.view)
        let o = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        var distance = CGFloat(sqrtf(powf(Float(p.x - o.x), 2.0) + powf(Float(p.y - o.y), 2.0)))
        let angle = CGFloat(atan2(p.y - o.y, p.x - o.x))
        distance = min(distance, 200.0)
        
        // Display an arrow showing the direction and magnitude of the applied impulse.
        (self.view as! APLDecorationView).drawMagnitudeVectorWithLength(distance, angle: angle, color: UIColor.red, forLimitedTime: false)
        
        // These two lines change the actual force vector.
        pushBehavior.magnitude = distance / 100.0
        pushBehavior.angle = angle
        
    }
    
}
