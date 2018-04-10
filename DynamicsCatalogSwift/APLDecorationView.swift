//
//  APLDecorationView.swift
//  DynamicsCatalogSwift
//
//  Created by Allan on 10/04/2018.
//  Copyright © 2018 Allan Pacheco. All rights reserved.
//

import UIKit

class APLDecorationView: UIView{
    
    var attachmentPointView: UIView?
    var attachedView: UIView?
    var attachmentOffset: CGPoint!
    //! Array of CALayer objects, each with the contents of an image for a dash.
    var attachmentDecorationLayers: [CALayer]!
    @IBOutlet weak var centerPointView: UIImageView!
    weak var arrowView: UIImageView!
    
    
    deinit {
        attachmentPointView?.removeObserver(self, forKeyPath: "center")
        attachedView?.removeObserver(self, forKeyPath: "center")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(patternImage: UIImage(named: "BackgroundTile")!)
    }
    
    /**
     Draws an arrow with a given @a length anchored at the center of the receiver,
     that points in the direction given by @a angle.
     */
    func drawMagnitudeVectorWithLength(_ length: CGFloat, angle: CGFloat, color: UIColor, forLimitedTime temporary: Bool){
        if self.arrowView == nil{
            let arrowImage = UIImage(named: "Arrow")!.withRenderingMode(.alwaysTemplate)
            let arrowImageView = UIImageView(image: arrowImage)
            arrowImageView.bounds = CGRect(x: 0, y: 0, width: arrowImage.size.width, height: arrowImage.size.height)
            arrowImageView.contentMode = .bottomRight
            arrowImageView.clipsToBounds = true
            arrowImageView.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            
            self.addSubview(arrowImageView)
            self.sendSubview(toBack: arrowImageView)
            self.arrowView = arrowImageView
        }
        
        self.arrowView.bounds = CGRect(x: 0, y: 0, width: length, height: self.arrowView.bounds.size.height)
        arrowView.transform = CGAffineTransform(rotationAngle: angle)
        self.arrowView.tintColor = color
        self.arrowView.alpha = 1
        
        if temporary{
            UIView.animate(withDuration: 1.0) {
                self.arrowView.alpha = 0
            }
        }
    }
    
    /**
     Draws a dashed line between @a attachmentPointView and @a attachedView
     that is updated as either view moves.
     */
    func trackAndDrawAttachmentFromView(_ attachmentPointView: UIView, toView attachedView: UIView, withAttachmentOffset attachmentOffset: CGPoint){
        
        if self.attachmentDecorationLayers == nil{
            self.attachmentDecorationLayers = [CALayer]()
            for i in 1...3{
                let dashImage = UIImage(named: "DashStyle\(i)")!
                let dashLayer = CALayer()
                dashLayer.contents = dashImage.cgImage!
                dashLayer.bounds = CGRect(x: 0, y: 0, width: dashImage.size.width, height: dashImage.size.height)
                dashLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
                self.layer.insertSublayer(dashLayer, at: 0)
                self.attachmentDecorationLayers.append(dashLayer)
            }
        }
        
        // A word about performance.
        // Tracking changes to the properties of any id<UIDynamicItem> involved in
        // a simulation incurs a performance cost.  You will receive a callback
        // during each step in the simulation in which the tracked item is not at
        // rest.  You should therefore strive to make your callback code as
        // efficient as possible.
        
        self.attachmentPointView?.removeObserver(self, forKeyPath: "center")
        self.attachedView?.removeObserver(self, forKeyPath: "center")
        
        self.attachmentPointView = attachmentPointView
        self.attachedView = attachedView
        self.attachmentOffset = attachmentOffset
        
        // Observe the 'center' property of both views to know when they move.
        self.attachmentPointView?.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.init(rawValue: 0), context: nil)
        self.attachedView?.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.init(rawValue: 0), context: nil)
        
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if arrowView != nil{
            self.arrowView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        }
        
        if self.centerPointView != nil{
            self.centerPointView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        }
        
        if self.attachmentDecorationLayers != nil{
            
            // Here we adjust the line dash pattern visualizing the attachement
            // between attachmentPointView and attachedView to account for a change
            // in the position of either.
            
            let maxDashes = self.attachmentDecorationLayers.count
            var attachmentPointViewCenter: CGPoint? = CGPoint(x: self.attachmentPointView!.bounds.size.width/2, y: self.attachmentPointView!.bounds.size.height/2)
            attachmentPointViewCenter = self.attachmentPointView?.convert(attachmentPointViewCenter!, to: self)
            var attachedViewAttachmentPoint = CGPoint(x: self.attachedView!.bounds.size.width/2 + self.attachmentOffset.x, y: self.attachedView!.bounds.size.height/2 + self.attachmentOffset.y)
            attachedViewAttachmentPoint = self.attachedView!.convert(attachedViewAttachmentPoint, to: self)
            
            let distance = CGFloat(sqrtf(powf(Float(attachedViewAttachmentPoint.x - attachmentPointViewCenter!.x), 2.0) + powf(Float(attachedViewAttachmentPoint.y - attachmentPointViewCenter!.y), 2.0)))
            let angle = CGFloat(atan2(Double(attachedViewAttachmentPoint.y-attachmentPointViewCenter!.y), Double(attachedViewAttachmentPoint.x-attachmentPointViewCenter!.x)))
            
            var requiredDashes = 0
            var d: CGFloat = 0.0
            
            // Depending on the distance between the two views, a smaller number of
            // dashes may be needed to adequately visualize the attachment.  Starting
            // with a distance of 0, we add the length of each dash until we exceed
            // 'distance' computed previously or we use the maximum number of allowed
            // dashes, 'MaxDashes'.
            
            while requiredDashes < maxDashes{
                let dashLayer = self.attachmentDecorationLayers[requiredDashes]
                if (d + dashLayer.bounds.size.height < distance){
                    d += dashLayer.bounds.size.height
                    dashLayer.isHidden = false
                    requiredDashes += 1
                }
                else{
                    break
                }
            }
            
            // Based on the total length of the dashes we previously determined were
            // necessary to visualize the attachment, determine the spacing between
            // each dash.
            
            let dashSpacing = (distance - d) / CGFloat(requiredDashes + 1)
            
            // Hide the excess dashes.
            for _ in requiredDashes ..< maxDashes{
                self.attachmentDecorationLayers[requiredDashes].isHidden = true
            }
            
            // Disable any animations.  The changes must take full effect immediately.
            CATransaction.begin()
            CATransaction.setAnimationDuration(0)
            
            // Each dash layer is positioned by altering its affineTransform.  We
            // combine the position of rotation into an affine transformation matrix
            // that is assigned to each dash.
            
            var transform = CGAffineTransform(translationX: attachmentPointViewCenter!.x, y: attachmentPointViewCenter!.y)
            transform = transform.rotated(by: angle - .pi / 2)
            
            for drawnDashes in 0..<requiredDashes{
                let dashLayer = self.attachmentDecorationLayers[drawnDashes]
                transform = transform.translatedBy(x: 0, y: dashSpacing)
                dashLayer.setAffineTransform(transform)
                transform = transform.translatedBy(x: 0, y: dashLayer.bounds.size.height)
            }
            
            CATransaction.commit()
            
        }
    
}

override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if (object as? UIView == self.attachmentPointView) || (object as? UIView == self.attachedView){
        self.setNeedsLayout()
    }
    else{
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
}


}
