//
//  CustomSegue.swift
//  homeWork_1
//
//  Created by Admin on 17.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    
    override func perform() {
        guard let containerView = source.view.superview else { return }
        containerView.addSubview(destination.view)
        
        let sourceFrame = self.source.view.frame
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                self.destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
                self.destination.view.frame = sourceFrame
                self.destination.view.transform = CGAffineTransform(rotationAngle: CGFloat(-90.0).toRadians())
            })
            
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
//                self.source.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
//                self.source.view.frame = sourceFrame
//            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3, animations: {
//                self.source.view.transform = CGAffineTransform(rotationAngle: CGFloat(90.0).toRadians())
                self.destination.view.transform = CGAffineTransform(rotationAngle: CGFloat(0).toRadians())
            })
        }, completion: { completition in
            
            self.source.view.transform = .identity
            self.source.present(self.destination,
                                animated: false,
                                completion: nil)
        })
    }
    
}
