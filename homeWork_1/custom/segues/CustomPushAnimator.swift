//
//  CustomPushAnimator.swift
//  homeWork_1
//
//  Created by Admin on 17.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        let sourceFrame = source.view.frame
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                transitionContext.containerView.addSubview(destination.view)
                destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
                destination.view.frame = sourceFrame
                
                let transform = CGAffineTransform(rotationAngle: CGFloat(-90.0).toRadians())
                let scale = CGAffineTransform(scaleX: 1, y: 1)
                destination.view.transform = transform.concatenating(scale)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3, animations: {
                let transform = CGAffineTransform(rotationAngle: CGFloat(0).toRadians())
                let scale = CGAffineTransform(scaleX: 1, y: 1)
                destination.view.transform = transform.concatenating(scale)
            })
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
    
    
    /*
     transitionContext.containerView.addSubview(destination.view)
     destination.view.frame = source.view.frame
     destination.view.transform = CGAffineTransform(translationX: source.view.frame.width, y: 0)
     
     
     UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .calculationModePaced, animations: {
     
     UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.75, animations: {
     let translation = CGAffineTransform(translationX: -200, y: 0)
     let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
     source.view.transform = translation.concatenating(scale)
     })
     
     UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4, animations: {
     let translation = CGAffineTransform(translationX: source.view.frame.width / 2, y: 0)
     let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
     destination.view.transform = translation.concatenating(scale)
     })
     
     UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
     destination.view.transform = .identity
     })
     }) { finished in
     if finished && !transitionContext.transitionWasCancelled {
     source.view.transform = .identity
     }
     transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
     }
     
     
     */
    
}
