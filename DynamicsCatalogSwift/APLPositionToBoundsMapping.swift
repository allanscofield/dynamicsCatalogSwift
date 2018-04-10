//
//  APLPositionToBoundsMapping.swift
//  DynamicsCatalogSwift
//
//  Created by Allan on 10/04/2018.
//  Copyright © 2018 Allan Pacheco. All rights reserved.
//

import UIKit

protocol ResizableDynamicItem: UIDynamicItem {
    var bounds: CGRect {get set}
}

class APLPositionToBoundsMapping: NSObject, UIDynamicItem {
    
    var target: UIButton!
    
    var center: CGPoint{
        get{
            // center.x <- bounds.size.width, center.y <- bounds.size.height
            return CGPoint(x: self.target.bounds.size.width, y: self.target.bounds.size.height)
        }
        set{
            self.target.bounds = CGRect(x: 0, y: 0, width: newValue.x, height: newValue.y)
        }
    }
    var bounds: CGRect{
        return self.target.bounds
    }
    var transform: CGAffineTransform{
        get{
            return self.target.transform
        }
        set{
            self.target.transform = newValue
        }
    }
    
    convenience init(target: UIButton) {
        self.init()
        self.target = target
    }
    
    func setCenter(_ center: CGPoint){
        self.center = center
    }
    
    
}
