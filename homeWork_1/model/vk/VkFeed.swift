//
//  VkNew.swift
//  homeWork_1
//
//  Created by Admin on 19.11.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class VkFeed {
    
    var sourceId = -1
    var sourceUrl = ""
    var sourceName = ""
    
    
    var feedId = -1
    var feedText = ""
    var feedDate = -1
    
    
    var attachments = [VkAttachment]()
    
    var countLikes = 0
    var countViews = 0
    var countReposts = 0
    var countComments = 0
    
    var isLiked = false
    
    func getFeedDate() -> String {
        
        let currentDate = Date().timeIntervalSince1970
        
        let diffInSeconds = currentDate - Double(feedDate)
        let diffInMinutes = diffInSeconds/60
        let diffInHours = diffInMinutes/60
        let diffInDays = diffInMinutes/24
        
        if (diffInDays < 1
            && diffInHours < 1
            && diffInMinutes < 1
            && diffInSeconds < 60) {
            return "\(Int(diffInSeconds)) секунд назад"
        } else if (diffInDays < 1
            && diffInHours < 1
            && diffInMinutes < 60) {
            return "\(Int(diffInMinutes)) минут назад"
        } else if (diffInDays < 1
            && diffInHours < 24) {
            return "\(Int(diffInHours)) часов назад"
        } else {
            return "\(Int(diffInDays)) дней назад"
        }
    }
    
    func getStringFrom(count: Int) -> String {
        if count > 1000000 {
            return String(format: "%.2f М ", Float(count)/1000000)
        } else if count > 1000 {
            return String(format: "%.2f К ", Float(count)/1000)
        } else if count > 0 {
            return "\(count)"
        } else {
            return ""
        }
    }
    
}

class VkAttachment { //only photo
    
    var imageUrl = ""
    var width = 0
    var height = 0
}
