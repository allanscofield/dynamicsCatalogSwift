//
//  APLCompositeBehaviorViewController.swift
//  DynamicsCatalogSwift
//
//  Created by Allan on 10/04/2018.
//  Copyright © 2018 Allan Pacheco. All rights reserved.
//

import UIKit

class APLCompositeBehaviorViewController: UIViewController {

    @IBOutlet weak var square: UIView!
    @IBOutlet weak var attachmentPoint: UIImageView!
    
    var animator: UIDynamicAnimator!
    var pendulumBehavior: APLPendulumBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attachmentPoint.tintColor = UIColor.red
        self.attachmentPoint.image = self.attachmentPoint.image?.withRenderingMode(.alwaysTemplate)
        
        // Visually show the connection between the attachment points.
        (self.view as! APLDecorationView).trackAndDrawAttachmentFromView(self.attachmentPoint, toView: self.square, withAttachmentOffset: CGPoint(x: 0, y: -0.95 * self.square.bounds.size.height / 2))
        animator = UIDynamicAnimator(referenceView: self.view)
        
        let pendulumAttachmentPoint = self.attachmentPoint.center
        
        // An example of a high-level behavior simulating a simple pendulum.
        pendulumBehavior = APLPendulumBehavior(withWeigh: self.square, suspendedFromPoint: pendulumAttachmentPoint)
        animator.addBehavior(pendulumBehavior)
    }

    @IBAction func dragWeight(_ sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            self.pendulumBehavior.beginDraggingWeightAtPoint(p: sender.location(in: self.view))
        case .ended:
            self.pendulumBehavior.endDraggingWeightWithVelocity(v: sender.velocity(in: self.view))
        case .cancelled:
            sender.isEnabled = true
            self.pendulumBehavior.endDraggingWeightWithVelocity(v: sender.velocity(in: self.view))
        default:
            if self.square.bounds.contains(sender.location(in: self.square)){
                // End the gesture if the user's finger moved outside square1's bounds.
                // This causes the gesture to transition to the cencelled state.
                sender.isEnabled = false
            }
            else{
                self.pendulumBehavior.dragWeightToPoint(p: sender.location(in: self.view))
            }
        }
    }
    

}
