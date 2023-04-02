//
//  VkCommentProfile.swift
//  homeWork_1
//
//  Created by Admin on 11/28/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class VkCommentProfile {
    
    var id = -1
    var firstname = ""
    var lastname = ""
    var sex = -1
    var screenname = ""
    var imageUrl50 = ""
    var imageUrl100 = ""
    var online = false
 
    func getFullName() -> String {
        return "\(firstname) \(lastname):"
    }
}
