//
//  GroupAdapter.swift
//  homeWork_1
//
//  Created by Александр Кукоба on 02.04.2023.
//  Copyright © 2023 Кукоба Александр. All rights reserved.
//

import Foundation
import RealmSwift

final class GroupAdapter {
    
    private let realmWorker = RealmWorker.instance
    var notificationToken: NotificationToken?
    
    func getGroups(completion: @escaping ([VkGroup]) -> Void) {
       
        var realm: Realm?
        do {
            realm = try Realm()
        } catch {
            print("REALM ERROR: error in initializing realm \(error)")
        }
        
        let realmGroups = realm!.objects(VkGroup.self)
        
        notificationToken = realmGroups.observe{(changes: RealmCollectionChange) in
            
            switch changes {
            case .initial(_):
                print("==========GROUP INITIAL==========")
            case .update(let collection, _, _, _):
                if !collection.isEmpty {
                    print("==========GROUP UPDATE==========")
                    var groups: [VkGroup] = []
                    for col in collection {
                        groups.append(col)
                    }
                    completion(groups)
                }
                else
                {
                    print("==========Empty GROUP update==========")
                }
            case .error(let err):
                print(err)
            }
        }
        AlamofireService.instance.getGroups()
    }
   
}
