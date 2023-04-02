//
//  VKApiViewController.swift
//  homeWork_1
//
//  Created by Admin on 23.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class VKApiViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonShow: UIButton!
    
    private var type = 0
    private var isLoad = false
    
    private var showText = true
    
    private var groups  = [VkGroup]()
    private var photos =  [VkPhoto]()
    private var friends = [VkFriend]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonText()
    }
    

    @IBAction func buttonShowClicked(_ sender: Any) {
        if (!isLoad) {
            isLoad = !isLoad
            getNewInfo()
        }
    }
    
    
    private func setButtonText() {
        var title = ""
        switch type {
        case 0:
            title = "Вывести друзей"
            break
            
        case 1:
            title = "Вывести группы"
            break
            
        case 2:
            title = "Найти группы (GeekBrains)"
            break
            
        case 3:
            title = "Вывести фотки"
            break
        
        default:
            title = "Вывести"
            break
        }
        buttonShow.setTitle(title, for: .normal)
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        showText = sender.selectedSegmentIndex == 0
    }
    
    
    private func getNewInfo() {
        switch type {
        case 0:
            getLocalFriends()
            break
            
        case 1:
            getLocalGroups()
            break
            
        case 2:
            getSearchedGroups()
            break
            
        case 3:
            getLocalPhotos()
            break
            
            
        default:
            break
        }
        type = (type + 1) % 4
        setButtonText()
    }
    
    
    private func getLocalFriends() {
        friends.removeAll()
        friends = RealmWorker.instance.getMyFriends()
        if friends.count > 0 {
            isLoad = !isLoad
//            showFriends()
        } else {
//            AlamofireService.instance.getFriends(delegate: self)
        }
    }
    
    private func getLocalGroups() {
        groups.removeAll()
        groups = RealmWorker.instance.getMyGroups()
        if groups.count > 0 {
            isLoad = !isLoad
//            showGroups()
        } else {
//            AlamofireService.instance.getGroups(delegate: self)
        }
    }
    
    private func getSearchedGroups() {
        groups.removeAll()
        groups = RealmWorker.instance.getSearchedGroups()
        if groups.count > 0 {
            isLoad = !isLoad
//            showGroups()
        } else {
//            AlamofireService.instance.searchGroups(delegate: self)
        }
    }
    
    private func getLocalPhotos() {
        photos.removeAll()
        photos = RealmWorker.instance.getMyPhotos()
        if photos.count > 0 {
            isLoad = !isLoad
//            showPhotos()
        } else {
//            AlamofireService.instance.getPhotos(delegate: self)
        }
    }
    
    
}

//extension VKApiViewController: VkApiViewControllerDelegate {
//
//    func returnString(text: String) {
//        isLoad = !isLoad
//        self.textView.text = "Ответ от сервера:\n\(text)"
//    }
//
//    func returnFriends(_ friends: [VkFriend]) {
//        isLoad = !isLoad
//        self.friends.removeAll()
//        self.friends = friends
//        showFriends()
//    }
//
//    func returnGroups(_ groups: [VkGroup]) {
//        isLoad = !isLoad
//        self.groups.removeAll()
//        self.groups = groups
//        showGroups()
//    }
//
//    func returnPhotos(_ photos: [VkPhoto]) {
//        isLoad = !isLoad
//        self.photos.removeAll()
//        self.photos = photos
//        showPhotos()
//    }
//
//
//    private func showFriends() {
//        var text = ""
//        for (index, friend) in self.friends.enumerated() {
//            text += "friend №\(index + 1)\n"
//            text += "id: \(friend.uid)\n"
//            text += "Фамилия: \(friend.last_name)\n"
//            text += "Имя: \(friend.first_name)\n\n"
//        }
//        self.textView.text = "\(text)"
//    }
//
//    private func showGroups() {
//        var text = ""
//        for (index, group) in self.groups.enumerated() {
//            text += "groups №\(index + 1)\n"
//            text += "id: \(group.gid)\n"
//            text += "Название: \(group.name)\n"
//            text += "Фото: \(group.photo)\n\n"
//        }
//        self.textView.text = "\(text)"
//    }
//
//    private func showPhotos() {
//        var text = ""
//        for (index, photo) in self.photos.enumerated() {
//            text += "photo №\(index + 1)\n"
//            text += "id: \(photo.pid)\n"
//            text += "Название: \(photo.text)\n"
//            text += "Фото: \(photo.photo)\n"
//            text += "Лайков: \(photo.likeCount())\n"
//            text += "Репостов: \(photo.repostCount())\n\n"
//        }
//        self.textView.text = "\(text)"
//    }
//
//}



