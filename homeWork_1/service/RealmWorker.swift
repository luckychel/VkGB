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
    static func getRealm() -> Realm? {
        
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
        if friends.count > 0 {
            do {
                Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
                let realm = try Realm()
                realm.beginWrite()
                realm.add(friends)
                try realm.commitWrite()
                
            } catch {
                print("Realm saveFriends error: \(error)")
            }
        } else {
             print("Realm saveFriends error: Empty friends List")
        }
    }
    
    
    func saveGroups(_ groups: [VkGroup]) {
        if groups.count > 0 {
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.add(groups)
                try realm.commitWrite()
                
            } catch {
                print("Realm saveGroups error: \(error)")
            }
        } else {
             print("Realm saveGroups error: Empty groups List")
        }
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
    
}
