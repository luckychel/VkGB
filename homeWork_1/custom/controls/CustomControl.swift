//
//  CustomControl.swift
//  homeWork_1
//
//  Created by User on 30.09.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

@IBDesignable class CustomControl: UIControl {
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    
    var delegate: FriendsViewControllerDelegate?
    
    var selectedTitle: String? = nil {
        didSet {
            self.updateSelectedTitle()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    
    func setupView() {
        for char in GlobalConstants.titles {
            let button = UIButton(type: .system)
            button.setTitle(char, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectTitle(_:)), for: .touchUpInside)
            self.buttons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: self.buttons)
        
        self.addSubview(stackView)
        
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
    
    private func updateSelectedTitle() {
        for (_, button) in self.buttons.enumerated() {
            button.isSelected = false
//            if button.titleLabel?.text == selectedTitle {
//                button.isSelected = true
//            } else {
//                button.isSelected = false
//            }
//            guard let selectedTitle = titles[index] else { continue }
//            button.isSelected =
//            button.isSelected = day == self.selectedDay
        }
    }
    
    
    @objc private func selectTitle(_ sender: UIButton) {
        guard let index = self.buttons.index(of: sender) else { return }
        self.selectedTitle = GlobalConstants.titles[index]
        if let delegate = delegate {
            if let title = selectedTitle {
                delegate.selectTitle(title: title)
            }
        }
    }
}

