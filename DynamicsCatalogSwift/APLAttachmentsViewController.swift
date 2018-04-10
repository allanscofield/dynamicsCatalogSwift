//
//  APLAttachmentsViewController.swift
//  DynamicsCatalogSwift
//
//  Created by Allan on 10/04/2018.
//  Copyright © 2018 Allan Pacheco. All rights reserved.
//

import UIKit

class APLAttachmentsViewController: UIViewController {

    @IBOutlet weak var square1: UIImageView!
    @IBOutlet weak var square1AttachmentView: UIImageView!
    @IBOutlet weak var attachmentView: UIImageView!
    
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animator = UIDynamicAnimator(referenceView: self.view)
        
        let collisionBehavior = UICollisionBehavior(items: [self.square1])
        // Creates collision boundaries from the bounds of the dynamic animator's
        // reference view (self.view).
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
        
        let squareCenterPoint = CGPoint(x: self.square1.center.x, y: self.square1.center.y - 110.0)
        let attachmentPoint = UIOffsetMake(14.0, 14.0)
        // By default, an attachment behavior uses the center of a view. By using a
        // small offset, we get a more interesting effect which will cause the view
        // to have rotation movement when dragging the attachment.
        attachmentBehavior = UIAttachmentBehavior(item: self.square1, offsetFromCenter: attachmentPoint, attachedToAnchor: squareCenterPoint)
        animator.addBehavior(attachmentBehavior)
        
        // Visually show the attachment points
        self.attachmentView.center = attachmentBehavior.anchorPoint
        self.attachmentView.tintColor = UIColor.red
        self.attachmentView.image = self.attachmentView.image?.withRenderingMode(.alwaysTemplate)

        self.square1AttachmentView.center = CGPoint(x: 25.0, y: 25.0)
        self.square1AttachmentView.tintColor = UIColor.blue
        self.square1AttachmentView.image = self.square1AttachmentView.image?.withRenderingMode(.alwaysTemplate)
        
        // Visually show the connection between the attachment points.
        (self.view as! APLDecorationView).trackAndDrawAttachmentFromView(self.attachmentView, toView: self.square1, withAttachmentOffset: CGPoint.zero)
        
    }

    @IBAction func handleSpringAttachmentGesture(_ sender: UIPanGestureRecognizer) {
        self.attachmentBehavior.anchorPoint = sender.location(in: self.view)
        self.attachmentView.center = self.attachmentBehavior.anchorPoint
    }

}
