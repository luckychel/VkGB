//
//  FriendsAdapter.swift
//  homeWork_1
//
//  Created by Александр Кукоба on 03.04.2023.
//  Copyright © 2023 Кукоба Александр. All rights reserved.
//

import Foundation
import RealmSwift

final class FriendsAdapter {
    
    private let realmWorker = RealmWorker.instance
    var notificationToken: NotificationToken?
    
    func getFriends(completion: @escaping ([VkFriend]) -> Void) {
       
        var realm: Realm?
        do {
            realm = try Realm()
        } catch {
            print("REALM ERROR: error in initializing realm \(error)")
        }
        
        let realmFriends = realm!.objects(VkFriend.self)
        
        notificationToken = realmFriends.observe{(changes: RealmCollectionChange) in
            
            switch changes {
            case .initial(_):
                print("==========FRIENDS INITIAL==========")
            case .update(let collection, _, _, _):
                if !collection.isEmpty {
                    print("==========FRIENDS UPDATE==========")
                    var friends: [VkFriend] = []
                    for col in collection {
                        friends.append(col)
                    }
                    completion(friends)
                }
                else {
                    print("==========Empty FRIENDS update==========")
                }
            case .error(let err):
                print(err)
            }
        }
        AlamofireService.instance.getFriends()
    }
   
}
