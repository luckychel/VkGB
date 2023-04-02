//
//  NewsAdapter.swift
//  homeWork_1
//
//  Created by Александр Кукоба on 02.04.2023.
//  Copyright © 2023 Кукоба Александр. All rights reserved.
//

import Foundation
import RealmSwift

final class NewsAdapter {
    
    private let realmWorker = RealmWorker.instance
    var notificationToken: NotificationToken?
    
    func getNews(startFrom: String, completion: @escaping ([VkFeed]) -> Void) {
       
        guard let realm = realmWorker.getRealm() else {
            return
        }
        let realmNews = realm.objects(VkFeedRealm.self)
        
        notificationToken = realmNews.observe{[weak self] (changes: RealmCollectionChange) in
            
            guard let self = self else { return }
            
            switch changes {
            case .initial(_):
                print("initial")
            case .update(let collection, _, _, _):
                var news: [VkFeed] = []
                for col in collection {
                    news.append(self.convertRealmVkFeedToVkFeed(col))
                }
                completion(news)
                print("update")
            case .error(let err):
                print(err)
            }
        }
        AlamofireService.instance.getNews(startFrom: startFrom)
    }
    
    private func convertRealmVkFeedToVkFeed(_ rlmVkFeed: VkFeedRealm) -> VkFeed {
        let vk = VkFeed()
        vk.sourceId = rlmVkFeed.sourceId
        vk.sourceUrl = rlmVkFeed.sourceUrl
        vk.sourceName = rlmVkFeed.sourceName
        vk.feedId = rlmVkFeed.feedId
        vk.feedText =  rlmVkFeed.feedText
        vk.feedDate = rlmVkFeed.feedDate
        rlmVkFeed.attachments.forEach{res in
            let att = VkAttachment()
            att.imageUrl = res.imageUrl
            att.height = res.height
            att.width = res.width
            vk.attachments.append(att)
        }
        vk.countLikes = rlmVkFeed.countLikes
        vk.countViews = rlmVkFeed.countViews
        vk.countReposts = rlmVkFeed.countReposts
        vk.countComments = rlmVkFeed.countComments
        vk.isLiked = rlmVkFeed.isLiked
        return vk
    }
}
