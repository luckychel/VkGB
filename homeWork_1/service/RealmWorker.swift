//
//  RealmWorker.swift
//  homeWork_1
//
//  Created by Admin on 09.11.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import RealmSwift

class RealmWorker {
    
    static let instance = RealmWorker()
    private init(){}
    
    static var configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    //MARK: получение объекта realm
    func getRealm() -> Realm? {
        
        var realm: Realm?
        do {
            realm = try Realm()
        } catch {
            print(error)
        }
        return realm

    }
    
    func saveItems<Element: Object>(items: [Element], needMigrate: Bool = false, needUpdate: Bool = true) -> Realm? {
        
        do {
            let realm = try Realm(configuration: RealmWorker.configuration)
            try realm.write {
                realm.add(items)
            }
            return realm
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func getItems<T: Object>(_ type: T.Type, in realm: Realm? = try? Realm(configuration: RealmWorker.configuration)) -> Results<T>? {
        return realm?.objects(type)
    }
    
    
    func removeItem<T: Object>(_ item: T, in realm: Realm? = try? Realm(configuration: RealmWorker.configuration)) {
        if let realm = realm {
            do {
                try realm.write {
                    realm.delete(item)
                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func saveFriends(_ friends: [VkFriend]) {
        guard friends.count > 0 else {
            print("saveFriends ToRealm error: Empty news List")
            return
        }
        
        guard let realm = RealmWorker.instance.getRealm() else { return }
        
        do {
            let oldGroups = realm.objects(VkFriend.self)
            realm.beginWrite()
            realm.delete(oldGroups)
            try realm.commitWrite()
            
        } catch {
            print("saveFriends To Realm error: \(error)")
        }
        
        try! realm.write({
            realm.add(friends)
        })
    }
    
    
    func saveGroups(_ groups: [VkGroup]) {

        guard groups.count > 0 else {
            print("saveGroups ToRealm error: Empty news List")
            return
        }
        
        guard let realm = RealmWorker.instance.getRealm() else { return }
        
        do {
            let oldGroups = realm.objects(VkGroup.self)
            realm.beginWrite()
            realm.delete(oldGroups)
            try realm.commitWrite()
            
        } catch {
            print("saveGroups To Realm error: \(error)")
        }
        
        try! realm.write({
            realm.add(groups)
        })
        
    }
    
    func savePhotos(_ photos: [VkPhoto]) {
        if photos.count > 0 {
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.add(photos)
                try realm.commitWrite()
            } catch {
                print("Realm getFriends error: \(error)")
            }
        } else {
            print("Realm savePhotos error: Empty groups List")
        }
    }
    
    
    func getMyFriends() -> [VkFriend] {
        var myFrieds = [VkFriend]()
        do {
            let realm = try Realm()
            let friends = realm.objects(VkFriend.self).sorted(byKeyPath: "uid")
            for friend in friends {
                myFrieds.append(friend)
            }
        } catch {
            print("Realm getMyFriends error: \(error)")
        }
        return myFrieds
    }
    
    
    func getMyGroups() -> [VkGroup] {
        var myGroups = [VkGroup]()
        do {
            let realm = try Realm()
            let groups = realm.objects(VkGroup.self).filter("is_member = 1").sorted(byKeyPath: "gid")
            for group in groups {
                myGroups.append(group)
            }
        } catch {
            print("Realm getMyGroups error: \(error)")
        }
        return myGroups
    }
    
    
    func getSearchedGroups() -> [VkGroup] {
        var myGroups = [VkGroup]()
        do {
            let realm = try Realm()
            let groups = realm.objects(VkGroup.self).filter("name CONTAINS 'GeekBrains'").sorted(byKeyPath: "gid")
            for group in groups {
                myGroups.append(group)
            }
        } catch {
            print("Realm getSearchedGroups error: \(error)")
        }
        return myGroups
    }
    
    
    func getMyPhotos() -> [VkPhoto] {
        var myPhotos = [VkPhoto]()
        do {
            let realm = try Realm()
            let photos = realm.objects(VkPhoto.self).sorted(byKeyPath: "pid")
            for photo in photos {
                myPhotos.append(photo)
            }
        } catch {
            print("Realm getMyPhotos error: \(error)")
        }
        return myPhotos
    }
    
    
    func saveNewsToRealm(news: [VkFeedRealm]) {
        
        guard news.count > 0 else {
            print("SaveNews To Realm error: Empty news List")
            return
        }
        
        guard let realm = RealmWorker.instance.getRealm() else { return }
        
        do {
            let oldGroups = realm.objects(VkFeedRealm.self)
            realm.beginWrite()
            realm.delete(oldGroups)
            try realm.commitWrite()
            
        } catch {
            print("SaveNews To Realm error: \(error)")
        }
        
        try! realm.write({
            realm.add(news)
        })
    }
    
    func getNewsFromRealm() -> [VkFeedRealm] {
        var news = [VkFeedRealm]()
        do {
            let realm = try Realm()
            let phs = realm.objects(VkFeedRealm.self)
            for ph in phs {
                news.append(ph)
            }
        } catch {
            print("GetNews From Realm error: \(error)")
        }
        return news
    }
    
    
}
