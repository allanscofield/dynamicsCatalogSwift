//
//  APLCollisionsGravitySpringViewController.swift
//  DynamicsCatalogSwift
//
//  Created by Allan on 10/04/2018.
//  Copyright © 2018 Allan Pacheco. All rights reserved.
//

import UIKit

class APLCollisionsGravitySpringViewController: UIViewController {

    
    @IBOutlet weak var square1: UIView!
    @IBOutlet weak var square1AttachmentView: UIImageView!
    @IBOutlet weak var attachmentView: UIImageView!
    
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animator = UIDynamicAnimator(referenceView: self.view)
        let gravityBeahvior = UIGravityBehavior(items: [self.square1])
        let collisionBehavior = UICollisionBehavior(items: [self.square1])
        
        let anchorPoint = CGPoint(x: self.square1.center.x, y: self.square1.center.y - 110.0)
        attachmentBehavior = UIAttachmentBehavior(item: self.square1, attachedToAnchor: anchorPoint)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        // These parameters set the attachment in spring mode, instead of a rigid
        // connection.
        attachmentBehavior.frequency = 1.0
        attachmentBehavior.damping = 0.1
        
        // Visually show the attachment point.
        self.attachmentView.center = attachmentBehavior.anchorPoint
        self.attachmentView.tintColor = UIColor.red
        self.attachmentView.image = self.attachmentView.image?.withRenderingMode(.alwaysTemplate)
        
        // Visually show the attachment point.
        self.square1AttachmentView.center = CGPoint(x: 50.0, y: 50.0)
        self.square1AttachmentView.tintColor = UIColor.blue
        self.square1AttachmentView.image = self.square1AttachmentView.image?.withRenderingMode(.alwaysTemplate)
        
        // Visually show the connection between the attachment points.
        (self.view as! APLDecorationView).trackAndDrawAttachmentFromView(self.attachmentView, toView: self.square1, withAttachmentOffset: CGPoint.zero)
        
        animator.addBehavior(attachmentBehavior)
        animator.addBehavior(collisionBehavior)
        animator.addBehavior(gravityBeahvior)
        
    }
    
    @IBAction func handleSpringAttachmentGesture(_ sender: UIGestureRecognizer) {
        self.attachmentBehavior.anchorPoint = sender.location(in: self.view)
        self.attachmentView.center = self.attachmentBehavior.anchorPoint
        
    }
    

    

}
