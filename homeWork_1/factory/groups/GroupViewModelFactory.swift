//
//  GroupViewModelFactory.swift
//  homeWork_1
//
//  Created by Александр Кукоба on 03.04.2023.
//  Copyright © 2023 Кукоба Александр. All rights reserved.
//

import UIKit
import SDWebImage

class GroupViewModelFactory {
    
    public func constructViewModels(groups: [VkGroup]) -> [GroupViewModel] {
        return groups.compactMap(self.viewModel)
    }
    
    private func viewModel(group: VkGroup) -> GroupViewModel {
        let name = group.name
        let type = group.getType()
        let member = group.is_member > 0 ? "Вы вступили" : ""
        var photo: UIImageView {
            let photo = UIImageView()
            if group.photo.count > 0 {
                photo.sd_setImage(with: URL(string: group.photoBig), placeholderImage: UIImage(named: "noPhoto"))
            }
            return photo
        }
        return GroupViewModel(name: name, type: type, member: member, photo: photo)
    }
}

