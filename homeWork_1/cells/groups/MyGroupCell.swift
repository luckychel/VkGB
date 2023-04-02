//
//  MyGroupCell.swift
//  homeWork_1
//
//  Created by Admin on 01.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SDWebImage

class MyGroupCell: UITableViewCell {

    @IBOutlet weak var imageAva: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelMember: UILabel!
    
    var group: VkGroup!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func load(_ group: VkGroup) {
        self.group = group
        
        labelName.text = group.name
        labelType.text = group.getType()
        labelMember.text = group.is_member > 0 ? "Вы вступили" : ""
        
        if group.photo.count > 0 {
            imageAva.sd_setImage(with: URL(string: group.photoBig), placeholderImage: UIImage(named: "noPhoto"))
        }
    }

}
