//
//  AlamofireService.swift
//  homeWork_1
//
//  Created by Admin on 06.11.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol VkApiFriendsDelegate {
    
    func returnFriends(_ friends: [VkFriend])
}

protocol VkApiGroupsDelegate {
    
    func returnGroups(_ groups: [VkGroup])
    func returnLeave(_ gid: Int)
    func returnLeave(_ error: String)
    func returnJoin(_ gid: Int)
    func returnJoin(_ error: String)
}

protocol VkApiPhotosDelegate {
    
    func returnPhotos(_ photos: [VkPhoto])
}

protocol VkApiFeedsDelegate {
    
    func returnFeeds(_ feeds: [VkFeed])
}

protocol VkApiCommentsDelegate {
    
    func returnComments(_ comments: [VkComment])
}


class AlamofireService {
    
    static let instance = AlamofireService()
    private init(){}
    
    
    //MARK: Друзья с делегатом
    func getFriends(delegate: VkApiFriendsDelegate) {
        let method = "friends.get"
        let fullRow = "\(GlobalConstants.vkApi)\(method)"
        let params: Parameters = [
            "access_token": Session.instance.token,
            "fields": "id,nickname,photo_100,status",
            "v": "5.131"
            ]
        
        AF.request(fullRow, method: .get, parameters: params)
            .responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
                let friends = VkResponseParser.instance
                    .parseFriends(result: response.result)
                DispatchQueue.main.async {
                    delegate.returnFriends(friends)
                }
        }
    }
    
    //MARK: Друзья без делегата
    func getFriends() {
        let method = "friends.get"
        let fullRow = "\(GlobalConstants.vkApi)\(method)"
        let params: Parameters = [
            "access_token": Session.instance.token,
            "fields": "id,nickname,photo_100,status",
            "v": "5.131"
            ]
        
        AF.request(fullRow, method: .get, parameters: params)
            .responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
                
                let friends = VkResponseParser.instance.parseFriends(result: response.result)

                RealmWorker.instance.saveFriends(friends)

        }
    }
    
    //MARK: Группы с делегатом
    func getGroups(delegate: VkApiGroupsDelegate) {
        let method = "groups.get"
        let fullRow = "\(GlobalConstants.vkApi)\(method)"//&v5.87
        let params: Parameters = [
            "access_token": Session.instance.token,
            "fields": "id,name",
            "extended": "1",
            "count":"100",
            "v": "5.131"
        ]
        
        AF.request(fullRow, method: .get, parameters: params)
            .responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
                let groups = VkResponseParser.instance
                    .parseGroups(result: response.result, isSearched: false)
                DispatchQueue.main.async {
                    delegate.returnGroups(groups)
                }
        }
    }
    
    //MARK: Группы без делегата
    func getGroups() {
        let method = "groups.get"
        let fullRow = "\(GlobalConstants.vkApi)\(method)"//&v5.87
        let params: Parameters = [
            "access_token": Session.instance.token,
            "fields": "id,name",
            "extended": "1",
            "count":"100",
            "v": "5.131"
        ]
        
        AF.request(fullRow, method: .get, parameters: params)
            .responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
        
            let groups = VkResponseParser.instance.parseGroups(result: response.result, isSearched: false)
                
            RealmWorker.instance.saveGroups(groups)
                
        }
    }
    
    //MARK: Выйти из группы
    func leaveGroup(gid: Int, delegate: VkApiGroupsDelegate) {
        let method = "groups.leave"
        let fullRow = "\(GlobalConstants.vkApi)\(method)"//&v5.87
        let params: Parameters = [
            "access_token": Session.instance.token,
            "group_id": "\(gid)",
            "v": "5.131"
        ]
        
        AF.request(fullRow, method: .get, parameters: params)
            .responseJSON(queue: DispatchQueue.global(qos: .userInteractive)){ response in
                let parseValid = VkResponseParser.instance
                    .parseJoinLeaveGroup(result: response.result)
                DispatchQueue.main.async {
                    parseValid ? delegate.returnLeave(gid) : delegate.returnLeave("В ходе запроса произошла ошибка")
                }
        }
    }
    
    //MARK: Присоединиться к группе
    func joinGroup(gid: Int, delegate: VkApiGroupsDelegate) {
        let method = "groups.join"
        let fullRow = "\(GlobalConstants.vkApi)\(method)"//&v5.87
        let params: Parameters = [
            "access_token": Session.instance.token,
            "group_id": "\(gid)",
            "v": "5.131"
        ]
        
        AF.request(fullRow, method: .get, parameters: params)
            .responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
                let parseValid = VkResponseParser.instance
                    .parseJoinLeaveGroup(result: response.result)
                DispatchQueue.main.async {
                    parseValid ? delegate.returnJoin(gid) : delegate.returnJoin("В ходе запроса произошла ошибка")
                }
        }
    }
    
    
    //MARK: Группы Поиск
    func searchGroups(search: String, delegate: VkApiGroupsDelegate) {
        let method = "groups.search"
        let fullRow = "\(GlobalConstants.vkApi)\(method)"//&v5.87
        let params: Parameters = [
            "access_token": Session.instance.token,
            "q": search,
            "extended": "1",
            "sort": "2",
            "v": "5.131"
        ]
        AF.request(fullRow, method: .get, parameters: params)
            .responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
                let groups = VkResponseParser.instance
                    .parseGroups(result: response.result, isSearched: true)
                DispatchQueue.main.async {
                    delegate.returnGroups(groups)
                }
        }
    }
    
    //MARK: Получение фотографий
    func getPhotos(delegate: VkApiPhotosDelegate) {
        let method = "photos.getAll"
        let fullRow = "\(GlobalConstants.vkApi)\(method)"//&v5.87
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "extended": "1",
            "count":"100",
            "v": "5.131"
        ]
        
        AF.request(fullRow, method: .get, parameters: params)
            .responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
                let photos = VkResponseParser.instance
                    .parsePhotos(result: response.result)
                DispatchQueue.main.async {
                    delegate.returnPhotos(photos)
                }
        }
    }
    
    //MARK: Получение фотографий по ID
    func getPhotosBy(_ id: Int, delegate: VkApiPhotosDelegate) {
        let method = "photos.getAll"
        let fullRow = "\(GlobalConstants.vkApi)\(method)"//&v5.87
        
        let params: Parameters = [
            "access_token": Session.instance.token,
            "extended": "1",
            "owner_id":"\(id)",
            "count":"100",
            "v": "5.131"
            //            "album_id":"saved"
        ]
        
        AF.request(fullRow, method: .get, parameters: params)
            .responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
                let photos = VkResponseParser.instance
                    .parsePhotos(result: response.result)
                DispatchQueue.main.async {
                    delegate.returnPhotos(photos)
                }
        }
    }
    
    //MARK: Получение новостей с делегатом
    func getNews(startFrom: String, delegate: VkApiFeedsDelegate) {
        let method = "newsfeed.get"
        let fullRow = "\(GlobalConstants.vkApi)\(method)"
        let params: Parameters = [
            "access_token": Session.instance.token,
            "filters": "post",
            "v": "5.131",
            "count":"20",
            "start_from":"\(startFrom)"
            //            "end_time":"\(1)"
        ]
        
        AF.request(fullRow, method: .get, parameters: params)
            .responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
                let feeds = VkResponseParser.instance.parseNews(result: response.result)
                DispatchQueue.main.async {
                    delegate.returnFeeds(feeds)
                }
        }
    }
    
    //MARK: Получение новостей с сохранением в Realm
    func getNews(startFrom: String) {
        let method = "newsfeed.get"
        let fullRow = "\(GlobalConstants.vkApi)\(method)"
        let params: Parameters = [
            "access_token": Session.instance.token,
            "filters": "post",
            "v": "5.131",
            "count":"20",
            "start_from":"\(startFrom)"
            //            "end_time":"\(1)"
        ]
        
        AF.request(fullRow, method: .get, parameters: params)
            .responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
                let feeds = VkResponseParser.instance.parseNews(result: response.result)
                
                var realmFeed = feeds.compactMap({ VkFeedRealm( sourceId: $0.sourceId, sourceUrl: $0.sourceUrl, sourceName: $0.sourceName, feedId: $0.feedId, feedText: $0.feedText, feedDate: $0.feedDate,
                    attachments: $0.attachments, countLikes: $0.countLikes,
                    countViews: $0.countViews, countReposts: $0.countReposts,
                    countComments: $0.countComments, isLiked: $0.isLiked
                    )
                                                })
                RealmWorker.instance.saveNewsToRealm(news: realmFeed)
        }
    }
    
    //MARK: Получение комментариев
    func getComments(ownerId: Int, postId: Int, delegate: VkApiCommentsDelegate) {
        //delegate: VkApiFeedsDelegate) {
        let method = "wall.getComments"
        let fullRow = "\(GlobalConstants.vkApi)\(method)"
        let params: Parameters = [
            "access_token": Session.instance.token,
            "filters": "post",
            "v": "5.131",
            "count":"50",
            "sort":"desc",
            "need_likes":"1",
            "extended":"1",
            "owner_id":"\(ownerId)",
            "post_id":"\(postId)"
        ]
        
        AF.request(fullRow, method: .get, parameters: params)
            .responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
                print(response.result)
                let comments = VkResponseParser.instance
                    .parseComments(result: response.result)
                DispatchQueue.main.async {
                    delegate.returnComments(comments)
                }
        }
    }
    
}

