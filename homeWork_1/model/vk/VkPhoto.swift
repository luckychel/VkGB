//
//  VkPhoto.swift
//  homeWork_1
//
//  Created by Admin on 29.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import RealmSwift

class VkPhoto: Object {
    
    @objc dynamic var aid = 0
    @objc dynamic var pid = 0
    @objc dynamic var width = 0
    @objc dynamic var height = 0
    @objc dynamic var created = 0
    @objc dynamic var ownerId = 0
    @objc dynamic var text = ""
    @objc dynamic var photo = ""
    @objc dynamic var photoBig = ""
    var likes = VkLikes()//LinkingObjects(fromType: VkLikes.self, property: "likes")//
    var reposts = VkReposts()//LinkingObjects(fromType: VkReposts.self, property: "reposts")
    
    
    override static func primaryKey() -> String? {
        return "pid"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
    
    public func likeCount() -> Int {
        return likes.count
    }
    
    public func repostCount() -> Int {
        return reposts.count
    }
    
    
    

}


class VkLikes: Object {

    @objc dynamic var count: Int = 0
    @objc dynamic var user_likes: Int = 0
}

class VkReposts: Object {

    @objc dynamic var count: Int = 0
}
