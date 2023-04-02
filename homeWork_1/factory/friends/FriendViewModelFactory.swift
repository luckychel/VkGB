//
//  FriendViewModelFactory.swift
//  homeWork_1
//
//  Created by Александр Кукоба on 03.04.2023.
//  Copyright © 2023 Кукоба Александр. All rights reserved.
//

import Foundation
import SDWebImage

class FriendViewModelFactory {
    
    public func constructViewModels(friends: [VkFriend]) -> [FriendViewModel] {
        return friends.compactMap(self.viewModel)
    }
    
    public func viewModel(friend: VkFriend) -> FriendViewModel {
        let fullName = friend.full_name
        var photo: UIImageView {
            let photo = UIImageView()
            if friend.photo.count > 0 {
                photo.sd_setImage(with: URL(string: friend.photo), placeholderImage: UIImage(named: "noPhoto"))
            }
            return photo
        }
        return FriendViewModel(fullName: fullName, photo: photo)
    }
}

