//
//  CustomSearchBar.swift
//  homeWork_1
//
//  Created by Admin on 10.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit


protocol CustomSearchBarDelegate {
    
    func textChanged(text: String)
    func cancelSearch()
}

class CustomSearchBar: UIView {

    private var textField = UITextField()
    private var buttonCancel = UIButton()
    private var imageView = UIImageView()
    
    var delegate: CustomSearchBarDelegate?
    
    private var isSearching = false

 
    func setSubViews(width: CGFloat) {
        self.backgroundColor = UIColor.vkColor
        textField.delegate = self
        textField.frame = CGRect(x: 10, y: (self.frame.height - 40) / 2, width: width - 20, height: 40)
        buttonCancel.frame = CGRect(x: width, y: 8, width: 0, height: 40)
        //(self.frame.height - 56) / 2, 56
        imageView.frame = CGRect(x: (width / 2) - 15, y: (self.frame.height / 2) - 15, width: 30, height: 30)
        
        buttonCancel.setTitle("Отмена", for: .normal)
        buttonCancel.setTitleColor(UIColor.white, for: .normal)
//        buttonCancel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        buttonCancel.backgroundColor = UIColor.red
        buttonCancel.cornerRadius = 5
        
        imageView.image = UIImage(named: "search")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.white
        
        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "Поиск...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.groupTableViewBackground])
        
        self.addSubview(textField)
        self.addSubview(buttonCancel)
        self.addSubview(imageView)
        
        buttonCancel.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    
    @objc func buttonClicked() {
        textField.endEditing(true)
        isSearching = false
        if let delegate = delegate {
            delegate.cancelSearch()
        }
        animateHide()
    }
    
    
    @objc func rotated() {
        if isSearching {
            animateShow()
        } else {
            animateHide()
        }
    }
    

}

extension CustomSearchBar: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        animateShow()
        isSearching = true
        return true
    }
    
    private func animateShow() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.7,
                       options: [],
                       animations: {
                        self.imageView.frame.origin.x = 5
        })
        
        UIView.animate(withDuration: 0.3, animations: {
            self.textField.frame = CGRect(x: 40, y: (self.frame.height - 40) / 2, width: self.frame.width - 98, height: 40)
            self.buttonCancel.frame = CGRect(x: self.frame.width - 88, y: 8, width: 80, height: 40)
            //(self.frame.height - 56) / 2, 56
        })
    }
    
    private func animateHide() {
        print("self.frame.width = \(self.frame.width)")
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.7,
                       options: [],
                       animations: {
                        self.imageView.frame.origin.x = (self.frame.width / 2) - 15
        })
        
        UIView.animate(withDuration: 0.3, animations: {
            self.textField.text = ""
            self.textField.frame = CGRect(x: 10, y: (self.frame.height - 40) / 2, width: self.frame.width - 20, height: 40)
            self.buttonCancel.frame = CGRect(x: self.frame.width, y: 8, width: 0, height: 40)
            //(self.frame.height - 56) / 2, 56
        })
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print ("textFieldDidChange text : \(textField.text!)")
        if let delegate = delegate {
            delegate.textChanged(text: textField.text!)
        }
    }
}




