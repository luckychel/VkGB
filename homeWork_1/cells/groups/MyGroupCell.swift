//
//  MyGroupCell.swift
//  homeWork_1
//
//  Created by Admin on 01.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit


class MyGroupCell: UITableViewCell {

    @IBOutlet weak var imageAva: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelMember: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func load(_ group: GroupViewModel) {
        labelName.text = group.name
        labelType.text = group.type
        labelMember.text = group.member
        imageAva = group.photo
    }

}
