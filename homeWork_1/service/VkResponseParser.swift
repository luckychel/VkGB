//
//  VkResponseParser.swift
//  homeWork_1
//
//  Created by Admin on 07.11.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class VkResponseParser {
    
    static let instance = VkResponseParser()
    private init(){}
    
    
    func parseFriends(result: AFResult<Any>) -> [VkFriend] {
        var friends = [VkFriend]()
        
        var firstnameArr = [String]()
        firstnameArr.append("Александр")
        firstnameArr.append("Alex")
        firstnameArr.append("Игорь")
        firstnameArr.append("Чармандер")
        firstnameArr.append("Пикачу")
        firstnameArr.append("Сквиртл")
        firstnameArr.append("Псайдак")
        
        var lastnameArr = [String]()
        lastnameArr.append("Пушкин")
        lastnameArr.append("Чехов")
        lastnameArr.append("")
        lastnameArr.append("Некрасов")
        lastnameArr.append("Достоевский")
        
        switch result {
        case .success(let value):
            let json = JSON(value)
            if let responses = json["response"].array {
                for response in responses {
                    if (response.dictionary != nil) {
                        let friend = VkFriend()
                        friend.uid = response["uid"].intValue
                        friend.online = response["online"].intValue
                        friend.user_id = response["user_id"].intValue
                        friend.photo = response["photo_100"].stringValue
                        friend.nickname = response["nickname"].stringValue
                        friend.last_name = response["last_name"].string ?? ""
                        friend.first_name = response["first_name"].string ?? ""
                        friend.generateFullName()
                        friends.append(friend)
                    } else {
                        print("is not Response")
                    }
                }
            } else {
                print ("parseFriends - error: какой-то косячок")
            }
            break
            
        case .failure(let error):
            print ("parseFriends - error: \(error.localizedDescription)")
            break
        }
        
        if friends.count > 0 {
            RealmWorker.instance.saveItems(items: friends, needMigrate: true)//saveFriends(friends)
        } else {
            friends = RealmWorker.instance.getMyFriends()//getItems(VkFriend.self)
        }
        
        return friends
    }
    
    func parseGroups(result: AFResult<Any>, isSearched: Bool) -> [VkGroup] {
        var groups = [VkGroup]()
        
        switch result {
        case .success(let value):
            let json = JSON(value)
            if let responses = json["response"].array {
                for response in responses {
                    if (response.dictionary != nil) {
                        let group = VkGroup()
                        group.gid = response["gid"].intValue
                        group.is_admin = response["is_admin"].intValue
                        group.is_closed = response["is_closed"].intValue
                        group.is_member = response["is_member"].intValue
                        group.name = response["name"].stringValue
                        group.photo = response["photo"].stringValue
                        group.photoBig = response["photo_big"].stringValue
                        group.photoMedium = response["photo_medium"].stringValue
                        group.type = response["type"].stringValue
                        groups.append(group)
                    } else {
                        print("is not Json")
                    }
                }
            } else {
                print ("parseGroups - error: какой-то косячок")
            }
            break
            
        case .failure(let error):
            print ("parseGroups - error: \(error.localizedDescription)")
            break
        }
        if !isSearched {
            if groups.count > 0 {
                RealmWorker.instance.saveItems(items: groups)//saveGroups(groups)//
            } else {
                groups = RealmWorker.instance.getMyGroups()//getItems(VkGroup.self)
            }
        }
        return groups.sorted(by: { $0.is_member > $1.is_member && $0.name < $1.name })

    }
    
    func parseJoinLeaveGroup(result: AFResult<Any>) -> Bool {
        
        switch result {
        case .success(let value):
            let json = JSON(value)
            if let response = json["response"].int {
                return response == 1
            }
            return false
            
        case .failure(let error):
            print ("parseJoinLeaveGroup - error: \(error.localizedDescription)")
            break
        }
        return false
    }
    
    func parsePhotos(result: AFResult<Any>) -> [VkPhoto] {
        var photos = [VkPhoto]()
        
        switch result {
        case .success(let value):
            let json = JSON(value)
            if let responses = json["response"].array {
                for response in responses {
                    if (response.dictionary != nil) {
                        let photo = VkPhoto()
                        photo.pid = response["pid"].intValue
                        photo.aid = response["aid"].intValue
                        photo.created = response["created"].intValue
                        photo.height = response["height"].intValue
                        photo.width = response["width"].intValue
                        photo.ownerId = response["owner_id"].intValue
                        photo.photo = response["src"].stringValue
                        photo.photoBig = response["src_big"].stringValue
                        photo.text = response["text"].stringValue
                        
                        photo.likes = VkLikes()
                        photo.likes.count = response["likes"]["count"].intValue
                        photo.likes.user_likes = response["likes"]["user_likes"].intValue
                        
                        photo.reposts = VkReposts()
                        photo.reposts.count = response["reposts"]["count"].intValue
                        photos.append(photo)
                    } else {
                        print("is not Response")
                    }
                }
            } else {
                print ("parsePhotos - error: какой-то косячок")
            }
            break
            
        case .failure(let error):
            print ("parsePhotos - error: \(error.localizedDescription)")
            break
        }
//        RealmWorker.instance.savePhotos(photos)
        return photos
    }

    
    func parseNews(result: AFResult<Any>) -> [VkFeed] {
        let nextFromNotification = Notification.Name("nextFromNotification")
        var feeds = [VkFeed]()
        var feedGroups = [VkGroup]()
        var feedProfiles = [VkFriend]()
        switch result {
        case .success(let value):
            let json = JSON(value)
            print ("parseNews: \(json)")
            if let nextFrom = json["response"]["next_from"].string {
                NotificationCenter.default.post(name: nextFromNotification, object: nil, userInfo: ["nextFrom": nextFrom])
            }
            if let groups = json["response"]["groups"].array {
                for group in groups {
                    let feedGroup = VkGroup()
                    feedGroup.gid = group["id"].intValue
                    feedGroup.name = group["name"].stringValue
                    feedGroup.photo = group["photo_200"].stringValue
                    feedGroups.append(feedGroup)
                }
            }
            
            if let profiles = json["response"]["profiles"].array {
                for profile in profiles {
                    let feedProfile = VkFriend()
                    feedProfile.uid = profile["id"].int ?? -1
                    feedProfile.first_name = profile["first_name"].string ?? ""
                    feedProfile.last_name = profile["last_name"].string ?? ""
                    feedProfile.photo = profile["photo_100"].stringValue
                    feedProfiles.append(feedProfile)
                }
            }
            
            if let items = json["response"]["items"].array {
                for item in items {
                    let feed = VkFeed()
                    feed.feedId = item["post_id"].intValue
                    feed.feedDate = item["date"].intValue
                    feed.feedText = item["text"].stringValue
                    
                    feed.sourceId = item["source_id"].int ?? -1
                    feed.countLikes = item["likes"]["count"].int ?? 0
                    feed.countViews = item["views"]["count"].int ?? 0
                    feed.countReposts = item["reposts"]["count"].int ?? 0
                    feed.countComments = item["comments"]["count"].int ?? 0
                    feed.isLiked = item["likes"]["user_likes"].intValue > 0
                    
                    var sourceId = item["source_id"].intValue
                    if sourceId < 0 {
                        sourceId = -sourceId
                        for group in feedGroups {
                            if group.gid == sourceId {
                                feed.sourceName = group.name
                                feed.sourceUrl = group.photo
                                break
                            }
                        }
                    } else {
                        for profile in feedProfiles {
                            if profile.uid == sourceId {
                                feed.sourceName = "\(profile.first_name) \(profile.last_name)"
                                feed.sourceUrl = profile.photo
                                break
                            }
                        }
                    }
                    if let attachments = item["attachments"].array {
                        for attachment in attachments {
                            if attachment["type"].stringValue == "photo" {
                                if let sizes = attachment["photo"]["sizes"].array {
                                    for size in sizes {
                                        if size["type"].stringValue == "x" {
                                            let attachment = VkAttachment()
                                            attachment.imageUrl = size["url"].stringValue
                                            attachment.width = size["width"].intValue
                                            attachment.height = size["height"].intValue
                                            feed.attachments.append(attachment)
                                        }
                                    }
                                }
                            }
                            break
                        }
                    }
                    feeds.append(feed)
                }
            }

            break
            
        case .failure(let error):
            print ("parsePhotos - error: \(error.localizedDescription)")
            break
        }
        return feeds
    }
    
    
    func parseComments(result: AFResult<Any>) -> [VkComment] {

        var comments = [VkComment]()
        var commentProfiles = [VkCommentProfile]()
        switch result {
        case .success(let value):
            let json = JSON(value)
            print ("parseComments: \(json)")
            
            if let jsonProfiles = json["response"]["profiles"].array {
                for jsonProfile in jsonProfiles {
                    let commentProfile = VkCommentProfile()
                    commentProfile.id = jsonProfile["id"].int ?? -1
                    commentProfile.firstname = jsonProfile["first_name"].string ?? ""
                    commentProfile.lastname = jsonProfile["last_name"].string ?? ""
                    commentProfile.sex = jsonProfile["sex"].int ?? -1
                    commentProfile.screenname = jsonProfile["screen_name"].string ?? ""
                    commentProfile.imageUrl50 = jsonProfile["photo_50"].string ?? ""
                    commentProfile.imageUrl100 = jsonProfile["photo_100"].string ?? ""
                    commentProfile.online = (jsonProfile["online"].int ?? 0) > 0
                    commentProfiles.append(commentProfile)
                }
            }
            
            if let jsonComments = json["response"]["items"].array {
                for jsonComment in jsonComments {
                    let comment = VkComment()
                    comment.id = jsonComment["id"].int ?? -1
                    comment.date = jsonComment["date"].int ?? -1
                    comment.text = jsonComment["text"].string ?? ""
                    comment.likesCount = jsonComment["likes"]["count"].int ?? 0
                    
                    if let fromId = jsonComment["from_id"].int {
                        for commentProfile in commentProfiles {
                            if fromId == commentProfile.id {
                                comment.sender = commentProfile
                                break
                            }
                        }
                    }
                    comments.append(comment)
                }
            }
            
            break
            
        case .failure(let error):
            print ("parsePhotos - error: \(error.localizedDescription)")
            break
        }
        return comments
    }
}
