//
//  MainGroupViewController.swift
//  homeWork_1
//
//  Created by Admin on 12/5/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class MainGroupViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerGroups: UIView!
    
    private var currentSegment = 0
    
    private lazy var myGroupsViewController: GroupsViewController = {
//        let vc = GroupsViewController()
        let vc = storyboard!.instantiateViewController(withIdentifier: "MyGroups")
        self.add(childViewController: vc)
        return vc as! GroupsViewController
    }()

    private lazy var searchGroupsViewController: SearchGroupViewController = {
        let vc = storyboard!.instantiateViewController(withIdentifier: "SearchGroups")
        self.add(childViewController: vc)
        return vc as! SearchGroupViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    private func configureView() {
        setSegmentedControlSettings()
        add(childViewController: myGroupsViewController)
    }
    
    
    private func setSegmentedControlSettings() {
        segmentedControl.backgroundColor = UIColor.vkColor
        segmentedControl.tintColor = .clear
        
        let fontNormal = UIFont.HelveticaNeue
        let fontSelect = UIFont.HelveticaNeueMedium
    
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: fontNormal,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: fontSelect,
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .selected)
        
    }
    
    @IBAction func segmentControlDidChanged(_ sender: Any) {
        if currentSegment != segmentedControl.selectedSegmentIndex {
            currentSegment = segmentedControl.selectedSegmentIndex
            
            switch segmentedControl.selectedSegmentIndex
            {
            case 0:
                add(childViewController: myGroupsViewController)
            case 1:
                add(childViewController: searchGroupsViewController)
            default:
                break;
            }
        }
    }
}

//MARK: - Work with ContainerView

extension MainGroupViewController {
    
    func add(childViewController: UIViewController) {
        for view in containerGroups.subviews {
            view.removeFromSuperview()
        }
        
        childViewController.view.frame = CGRect(x: 0, y: 0, width: containerGroups.frame.width, height: containerGroups.frame.height)//containerGroups.frame
        
        containerGroups.addSubview(childViewController.view)

    }
    
}
