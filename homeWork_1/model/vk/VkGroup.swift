//
//  VkGroup.swift
//  homeWork_1
//
//  Created by Admin on 29.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import RealmSwift

class VkGroup: Object {
    
    @objc dynamic var gid = 0
    @objc dynamic var is_admin = 0
    @objc dynamic var is_closed = 0
    @objc dynamic var is_member = 0
    @objc dynamic var name = ""
    @objc dynamic var type = ""
    @objc dynamic var photo = ""
    @objc dynamic var photoBig = ""
    @objc dynamic var screenName = ""
    @objc dynamic var photoMedium = ""
    
    override static func primaryKey() -> String? {
        return "gid"
    }
    
    override static func indexedProperties() -> [String] {
        return ["name", "is_member"]
    }
    
    
    func getType() -> String {
        switch type {
        case "event":
            return "Мероприятие"
        case "group":
            return "Группа"
        case "page":
            return "Публичная страница"
        default:
            return ""
        }
    }
    
    func getSGroup() ->SGroup {
        return SGroup(gid: self.gid, is_admin: self.is_admin, is_closed: self.is_closed, is_member: self.is_member, name: self.name,
                            type: self.type, photo: self.photo, photoBig: self.photoBig, screenName: self.screenName, photoMedium: self.photoMedium)
    }
}


struct SGroup {
    var gid: Int
    var is_admin: Int
    var is_closed: Int
    var is_member: Int
    var name: String
    var type: String
    var photo: String
    var photoBig: String
    var screenName: String
    var photoMedium: String
    
    var toAnyObject: Any {
        return [
            "gid": gid,
            "is_admin": is_admin,
            "is_closed": is_closed,
            "is_member": is_member,
            "name": name,
            "type": type,
            "photo": photo,
            "photoBig": photoBig,
            "screenName": screenName,
            "photoMedium": photoMedium
        ]
    }
}
