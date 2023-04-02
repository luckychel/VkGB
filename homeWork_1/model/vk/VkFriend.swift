//
//  VkFriend.swift
//  homeWork_1
//
//  Created by Admin on 29.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import RealmSwift

class VkFriend: Object {//, Codable : Object
    
    @objc dynamic var uid = 0
    @objc dynamic var online = 0
    @objc dynamic var user_id = 0
    @objc dynamic var nickname = ""
    @objc dynamic var last_name = ""
    @objc dynamic var first_name = ""
    @objc dynamic var full_name = ""
    @objc dynamic var photo = ""
    
    
    override static func primaryKey() -> String? {
        return "uid"
    }
    
    override static func indexedProperties() -> [String] {
        return ["first_name", "last_name"]
    }
    
    
    func generateFullName() {
        self.full_name = (first_name.count > 0 ? (first_name + " ") : "") + (last_name.count > 0 ? last_name : "")
    }
    
    




    
}
