//
//  FirebaseService.swift
//  homeWork_1
//
//  Created by User on 01.12.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FirebaseService {
    
    private static let baseUrl = "https://shortvk.firebaseio.com/"
    static let instance = FirebaseService()
    static let dbLink = Database.database().reference()
    private init(){}
    
    func addUser() {
        FirebaseService.dbLink.child("users").childByAutoId().setValue(Session.instance.token)
    }
    
    
    func addGroup(group: VkGroup) {
        FirebaseService.dbLink.child("groups").child(Session.instance.token).child("\(group.gid)").setValue(group.getSGroup().toAnyObject)//data
    }
    
    
    func removeGroup(group: VkGroup) {
        let fGroup = FirebaseService.dbLink.child("groups").child(Session.instance.token).child("\(group.gid)")
        
        fGroup.removeValue { error, _ in
            print("firebase remove error: \(error?.localizedDescription)")
        }
    }
    
}



struct SUser {
    let token: String
    var groups: [SGroup]
    
    var toAnyObject: Any {
        return [
            "token": token,
            "groups": groups.map { $0.toAnyObject }
        ]
    }
}



