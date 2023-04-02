//
//  VkNew.swift
//  homeWork_1
//
//  Created by Admin on 19.11.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import RealmSwift

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



class VkFeedRealm: Object {
    
    @objc dynamic var feedId: Int = -1
    @objc dynamic var sourceId = -1
    @objc dynamic var sourceUrl = ""
    @objc dynamic var sourceName = ""

    @objc dynamic var feedText = ""
    @objc dynamic var feedDate = -1

    var attachments: [VkAttachmentRealm] = []
    
    @objc dynamic var countLikes = 0
    @objc dynamic var countViews = 0
    @objc dynamic var countReposts = 0
    @objc dynamic var countComments = 0
    
    @objc dynamic var isLiked = false
    
    @objc override open class func primaryKey() -> String? {
        return "feedId"
    }
    
    convenience init(sourceId: Int, sourceUrl: String, sourceName: String, feedId: Int, feedText: String, feedDate: Int,
                     attachments: [VkAttachment], countLikes: Int, countViews: Int, countReposts: Int, countComments: Int, isLiked: Bool) {
        self.init()
        self.sourceId = sourceId
        self.sourceUrl = sourceUrl
        self.sourceName = sourceName
        self.feedId = feedId
        self.feedText =  feedText
        self.feedDate = feedDate
        attachments.forEach{res in
            let att = VkAttachmentRealm()
            att.imageUrl = res.imageUrl
            att.height = res.height
            att.width = res.width
            self.attachments.append(att)
        }
        self.countLikes = countLikes
        self.countViews = countViews
        self.countReposts = countReposts
        self.countComments = countComments
        self.isLiked = isLiked
        
    }
    
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

class VkAttachmentRealm: Object {
    
    @objc dynamic var imageUrl = ""
    @objc dynamic var width = 0
    @objc dynamic var height = 0
}
