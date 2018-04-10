//
//  APLGravityViewController.swift
//  DynamicsCatalogSwift
//
//  Created by Allan on 10/04/2018.
//  Copyright © 2018 Allan Pacheco. All rights reserved.
//

import UIKit

class APLGravityViewController: UIViewController {

    @IBOutlet weak var square1: UIImageView!
    
    var animator: UIDynamicAnimator!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animator = UIDynamicAnimator(referenceView: self.view)
        let gravityBehavior = UIGravityBehavior(items: [self.square1])
        animator.addBehavior(gravityBehavior)
    }

}
