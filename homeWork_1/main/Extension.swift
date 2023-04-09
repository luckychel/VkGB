//
//  Extension.swift
//  homeWork_1
//
//  Created by User on 30.09.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class Session {
    
    static let instance = Session()
    
    private init(){}
    
    var token = ""
    var userId = 0
}


struct GlobalConstants {
    
    static var titles = [String]()

    static let defaults = UserDefaults.standard
    
    static let vkApi = "https://api.vk.com/method/"

}


@IBDesignable extension UIView {
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
    
    
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            return nil
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
}


extension UIColor {
    
    static let vkColor = UIColor(red: 65/255, green: 107/255, blue: 158/255, alpha: 1)
    
    private static var colorsCache: [String: UIColor] = [:]
    
    public static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, a: CGFloat) -> UIColor {

        let key = "\(r)\(g)\(b)\(a)"

        if let cachedColor = self.colorsCache[key] {
            return cachedColor
        }
        
        self.clearColorsCacheIfNeeded()
        
        let color = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)

        self.colorsCache[key] = color
        
        return color
    }
        
    private static func clearColorsCacheIfNeeded() {

        let maxObjectsCount = 100
        
        guard self.colorsCache.count > maxObjectsCount else { return }
        
        colorsCache = [:]
    }
}

extension UIFont {
    static let HelveticaNeue = UIFont(name: "HelveticaNeue", size: 17) ?? UIFont()
    static let HelveticaNeueMedium = UIFont(name: "HelveticaNeue-Medium", size: 17) ?? UIFont()
}



extension CGFloat {
    func toRadians() -> CGFloat {
        return self * .pi / 180.0
    }
}


