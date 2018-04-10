//
//  APLItemPropertiesViewController.swift
//  DynamicsCatalogSwift
//
//  Created by Allan on 10/04/2018.
//  Copyright © 2018 Allan Pacheco. All rights reserved.
//

import UIKit

class APLItemPropertiesViewController: UIViewController {
    
    @IBOutlet weak var square1: UIView!
    @IBOutlet weak var square2: UIView!

    var square1PropertiesBehavior: UIDynamicItemBehavior!
    var square2PropertiesBehavior: UIDynamicItemBehavior!
    var animator: UIDynamicAnimator!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animator = UIDynamicAnimator(referenceView: self.view)
        
        // We want to show collisions between views and boundaries with different
        // elasticities, we thus associate the two views to gravity and collision
        // behaviors. We will only change the restitution parameter for one of these
        // views.
        let gravityBeahvior = UIGravityBehavior(items: [square1, square2])
        let collisionBehavior = UICollisionBehavior(items: [square1, square2])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        // A dynamic item behavior gives access to low-level properties of an item
        // in Dynamics, here we change restitution on collisions only for square2,
        // and keep square1 with its default value.
        
        square2PropertiesBehavior = UIDynamicItemBehavior(items: [self.square2])
        square2PropertiesBehavior.elasticity = 0.5
        
        // A dynamic item behavior is created for square1 so it's velocity can be
        // manipulated in the -resetAction: method.
        square1PropertiesBehavior = UIDynamicItemBehavior(items: [self.square1])
        
        animator.addBehavior(square1PropertiesBehavior)
        animator.addBehavior(square2PropertiesBehavior)
        animator.addBehavior(gravityBeahvior)
        animator.addBehavior(collisionBehavior)
    }
    
    @IBAction func replayAction(_ sender: Any) {
        
        // Moving an item does not reset its velocity.  Here we do that manually
        // using the dynamic item behaviors, adding the inverse velocity for each
        // square.
       square1PropertiesBehavior.addLinearVelocity(CGPoint(x: 0, y: self.square1PropertiesBehavior.linearVelocity(for: self.square1).y), for: self.square1)
        self.square1.center = CGPoint(x: 90, y: 171)
        self.animator.updateItem(usingCurrentState: self.square1)
        
        square2PropertiesBehavior.addLinearVelocity(CGPoint(x: 0, y: self.square2PropertiesBehavior.linearVelocity(for: self.square2).y), for: self.square2)
        self.square2.center = CGPoint(x: 230, y: 171)
        self.animator.updateItem(usingCurrentState: self.square2)
    }
    


}
