//
//  CustomSquareIndicator.swift
//  homeWork_1
//
//  Created by Admin on 15.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class CustomSquareIndicator: UIActivityIndicatorView {
    //Для того, чтобы сделать квадрат
    private var mainView = UIView()
    private let myLayer = CAShapeLayer()
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if (self.frame.width > self.frame.height) {
            mainView.frame = CGRect(x: (self.frame.width - self.frame.height) / 2, y: 0, width: self.frame.height, height: self.frame.height)
        } else {
            mainView.frame = CGRect(x: 0, y: (self.frame.height - self.frame.width) / 2, width: self.frame.width, height: self.frame.width)
        }
        mainView.backgroundColor = UIColor.clear
       
        self.addSubview(mainView)
    }
    
    
    override func startAnimating() {
        self.backgroundColor = UIColor(red: 24/255, green: 139/255, blue: 243/255, alpha: 1)
        
        myLayer.path = nil
        myLayer.lineWidth = 4
        
        myLayer.strokeColor = UIColor(red: 238/255, green: 243/255, blue: 251/255, alpha: 1).cgColor
        myLayer.fillColor = UIColor(red: 92/255, green: 175/255, blue: 248/255, alpha: 1).cgColor
        
        let path = returnPath()
        path.close()
        path.stroke()
        myLayer.path = path.cgPath
        myLayer.lineCap = CAShapeLayerLineCap.round
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1.4
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 2
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        animationGroup.repeatCount = .greatestFiniteMagnitude
        
        mainView.layer.addSublayer(myLayer)
        myLayer.add(animationGroup, forKey: nil)
    }
    
    override func stopAnimating() {
        mainView.layer.removeAllAnimations()
    }
    
    
    private func returnPath() -> UIBezierPath {
        let width = mainView.frame.width
        let height = mainView.frame.height * 9/10
        
        let arcRadius:CGFloat = width / 5
        let arcCenter = CGPoint(x: arcRadius, y: height - arcRadius)
        
        let cloudPath = UIBezierPath()
        cloudPath.move(to: CGPoint(x: width / 2, y: height))
        cloudPath.addLine(to: CGPoint(x: arcRadius, y: height))
        
        cloudPath.addArc(withCenter: arcCenter,
                    radius: arcRadius,
                    startAngle: CGFloat(90.0).toRadians(),
                    endAngle: CGFloat(270.0).toRadians(),
                    clockwise: true)
        
        
        let arcRadius2 = width / 2 - arcRadius
        let arcCenter2 = CGPoint(x: width / 2, y: height - 2 * arcRadius)
        
        cloudPath.addArc(withCenter: arcCenter2,
                    radius: arcRadius2,
                    startAngle: CGFloat(180.0).toRadians(),
                    endAngle: CGFloat(315.0).toRadians(),
                    clockwise: true)
        
        let arcCenter3 = CGPoint(x: width / 2 + arcRadius2 * CGFloat(sqrt(3)) / 2, y: height - (height - (arcCenter2.y - arcRadius2 / 2)) / 2)
        let arcRadius3 = (height - arcCenter3.y)
        cloudPath.addArc(withCenter: arcCenter3,
                    radius: arcRadius3,
                    startAngle: CGFloat(270.0).toRadians(),
                    endAngle: CGFloat(90.0).toRadians(),
                    clockwise: true)
        cloudPath.close()
        return cloudPath
    }
    
}
