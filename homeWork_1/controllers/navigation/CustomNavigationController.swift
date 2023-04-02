//
//  CustomNavigationController.swift
//  homeWork_1
//
//  Created by Admin on 17.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    let interactiveTransition = CustomInteractiveTransition()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

}

extension CustomNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            if operation == .push {
                self.interactiveTransition.viewController = toVC
                return CustomPushAnimator()
            } else if operation == .pop {
                if navigationController.viewControllers.first != toVC {
                    self.interactiveTransition.viewController = toVC
                }
                return CustomPopAnimator()
            }
            return nil
    }
    
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            return interactiveTransition.hasStarted ? interactiveTransition : nil
    }

    
}
