//
//  APLSnapViewController.swift
//  DynamicsCatalogSwift
//
//  Created by Allan on 10/04/2018.
//  Copyright © 2018 Allan Pacheco. All rights reserved.
//

import UIKit

class APLSnapViewController: UIViewController {

    @IBOutlet weak var square1: UIView!
    
    var animator: UIDynamicAnimator!
    //! Reference to the previously applied snap behavior.
    var snapBehavior: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: self.view)
    }

    @IBAction func handleSnapGesture(_ sender: UITapGestureRecognizer) {
        
        let point = sender.location(in: self.view)
        
        // Remove the previous behavior.
        if snapBehavior != nil{
            animator.removeBehavior(self.snapBehavior)
        }
        
        snapBehavior = UISnapBehavior(item: self.square1, snapTo: point)
        animator.addBehavior(snapBehavior)
    }
    

}
