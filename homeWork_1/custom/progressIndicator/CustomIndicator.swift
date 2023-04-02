//
//  CustomIndicator.swift
//  homeWork_1
//
//  Created by Admin on 09.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class CustomIndicator: UIActivityIndicatorView {
    //Для того, чтобы сделать квадрат
    private var mainView = UIView()
    
    //круги будем помещать в квадрат
    private var circle1 = UIView()
    private var circle2 = UIView()
    private var circle3 = UIView()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.

    */

    
    override func draw(_ rect: CGRect) {
        if (self.frame.width > self.frame.height) {
            mainView.frame = CGRect(x: (self.frame.width - self.frame.height) / 2, y: 0, width: self.frame.height, height: self.frame.height)
        } else {
            mainView.frame = CGRect(x: 0, y: (self.frame.height - self.frame.width) / 2, width: self.frame.width, height: self.frame.width)
        }
        mainView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        mainView.cornerRadius = 5//mainView.frame.width/2
        
        // Длина и высота круга
        let circleSize = mainView.frame.width / 5
        
        
        // сторона треугольника
        let triangleSize = mainView.frame.width / 2
        
        // формула высоты равностороннего треугольника
        // h = sqrt(3) * size / 2
        let triangleHeight = (CGFloat(3.squareRoot()) * triangleSize) / 2
        
        // формула радиуса описанного круга
        // r = sqrt(3) * size / 3
        let radius = (triangleHeight * 2) / 3
        // - (circleSize / 2)
//        circle1.frame = CGRect(x: triangleSize - (circleSize / 2), y: triangleSize - radius - (circleSize / 2), width: circleSize, height: circleSize)
//
//        circle2.frame = CGRect(x: (triangleSize / 2) - (circleSize / 2), y: triangleSize + (triangleHeight / 3) - (circleSize / 2), width: circleSize, height: circleSize)
//
//        circle3.frame = CGRect(x: (triangleSize * 3 / 2) - (circleSize / 2), y: triangleSize + (triangleHeight / 3) - (circleSize / 2), width: circleSize, height: circleSize)
        
        circle1.frame = CGRect(x: triangleSize - (circleSize / 2), y: triangleSize - (triangleHeight / 2) - (circleSize / 2), width: circleSize, height: circleSize)
        
        circle2.frame = CGRect(x: (triangleSize / 2) - (circleSize / 2), y: triangleSize + (triangleHeight / 2) - (circleSize / 2), width: circleSize, height: circleSize)
        
        circle3.frame = CGRect(x: (triangleSize * 3 / 2) - (circleSize / 2), y: triangleSize + (triangleHeight / 2) - (circleSize / 2), width: circleSize, height: circleSize)
        
        circle1.layer.cornerRadius = circleSize / 2
        circle2.layer.cornerRadius = circleSize / 2
        circle3.layer.cornerRadius = circleSize / 2
       
        circle1.backgroundColor = UIColor.lightGray
        circle2.backgroundColor = UIColor.lightGray
        circle3.backgroundColor = UIColor.lightGray
        
        mainView.addSubview(circle1)
        mainView.addSubview(circle2)
        mainView.addSubview(circle3)
        self.addSubview(mainView)
        
    }
    
    override func startAnimating() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.circle2.alpha = 0.2
        })
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.circle1.alpha = 0.2
        })
        UIView.animate(withDuration: 0.3, delay: 0.4, options: [.repeat, .autoreverse], animations: {
            self.circle3.alpha = 0.2
        })
    }
}
