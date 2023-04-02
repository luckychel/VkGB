//
//  CustomInteractiveTransition.swift
//  homeWork_1
//
//  Created by Admin on 18.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    var hasStarted: Bool = false
    var shouldFinish: Bool = false
    
    
    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    
    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            print ("translation = \(translation)")
            print ("translation.y = \(translation.y)")
            let relativeTranslation = translation.y / (recognizer.view?.frame.width)! //(recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            print("progress = \(progress)")
            self.shouldFinish = progress > 0.33
            self.update(progress)
            
        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
            
        case .cancelled:
            self.hasStarted = false
            self.cancel()
            
        default: return
        }
    }
    
}
