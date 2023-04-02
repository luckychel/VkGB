//
//  TestViewController.swift
//  homeWork_1
//
//  Created by Admin on 1/14/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import PinLayout


class TestViewController: UIViewController {
    
    
    
    @IBOutlet weak var labelHeader: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    private func setLayout() {
        let padding: CGFloat = 10
        labelHeader.pin.top(80).left(padding).right(padding)//topLeft(padding).right(padding)
        labelHeader.text = "Hello motherfuckers Hello motherfuckers Hello motherfuckers Hello motherfuckers Hello motherfuckers "
        self.view.layoutIfNeeded()
//        labelHeader.pin.top(pin.safeArea).left(pin.safeArea).width(100).aspectRatio().margin(padding)
//        segmented.pin.after(of: logo, aligned: .top).right(pin.safeArea).marginHorizontal(padding)
//        textLabel.pin.below(of: segmented, aligned: .left).width(of: segmented).pinEdges().marginTop(10).sizeToFit(.width)
    }
    



}
