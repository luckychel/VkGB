//
//  NewsInfoTableViewCell.swift
//  homeWork_1
//
//  Created by Admin on 11/28/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class NewsInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewGroup: UIImageView!
    @IBOutlet weak var labelFeedGroupHeader: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var labelText: UILabel!
    
    
    
    @IBOutlet weak var buttonLike: CustomLike!
    
    @IBOutlet weak var imageComment: UIImageView!
    
    @IBOutlet weak var imageNew: UIImageView!
    @IBOutlet weak var labelCountViews: UILabel!
    
    @IBOutlet weak var imageViewLike: UIImageView!
    @IBOutlet weak var labelLike: UILabel!
    
    @IBOutlet weak var imageViewComment: UIImageView!
    @IBOutlet weak var labelComment: UILabel!
    
    @IBOutlet weak var imageViewShare: UIImageView!
    @IBOutlet weak var labelShare: UILabel!
    
    @IBOutlet weak var imageViewViews: UIImageView!
    @IBOutlet weak var labelViews: UILabel!
    
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    var delegate: NewsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewLike.tintColor = UIColor.lightGray
        imageViewShare.tintColor = UIColor.lightGray
        imageViewComment.tintColor = UIColor.lightGray
        imageViewViews.tintColor = UIColor.lightGray
    }
    
    
    override func prepareForReuse() {
        labelText.text = ""
        labelFeedGroupHeader.text = ""
        imageHeightConstraint.constant = 0
        self.layoutIfNeeded()
        //        setTaps()
    }
    
    
    func load(feed: VkFeed) {
        labelFeedGroupHeader.text = feed.sourceName
        labelDate.text = feed.getFeedDate()
        labelText.text = feed.feedText
        
        imageViewGroup.sd_setImage(with: URL(string: feed.sourceUrl), placeholderImage: UIImage(named: "noPhoto"))
        
        if feed.attachments.count > 0 {
            imageHeightConstraint.constant = self.frame.width * CGFloat(feed.attachments[0].height) / CGFloat(feed.attachments[0].width)
            
            imageNew.sd_setImage(with: URL(string: feed.attachments[0].imageUrl), placeholderImage: UIImage(named: "noPhoto"))
        } else {
            imageHeightConstraint.constant = 0
        }
        self.layoutIfNeeded()
        
        labelLike.text = feed.getStringFrom(count: feed.countLikes)
        labelViews.text = feed.getStringFrom(count: feed.countViews)
        labelShare.text = feed.getStringFrom(count: feed.countReposts)
        labelComment.text = feed.getStringFrom(count: feed.countComments)
    }
    
    func loadData(new: New, needPhoto: Bool) {
        buttonLike.setupView(isLiked: new.isLiked, countLikes: new.likeCount)
        setTaps()
    }
    
    
    
    
    private func setTaps() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        imageNew.addGestureRecognizer(imageTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.likeTapped(_:)))
        buttonLike.addGestureRecognizer(tap)
        
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(self.commentTapped(_:)))
        imageComment.addGestureRecognizer(commentTap)
    }
    
    
    @objc func likeTapped(_ sender: UITapGestureRecognizer) {
        UIView.transition(with: buttonLike,
                          duration: 0.25,
                          options: buttonLike.isLiked ? .transitionFlipFromRight : .transitionFlipFromLeft,
                          animations: {
                            self.buttonLike.changeLike()
        })
        if let delegate = delegate {
            delegate.changeLike(row: buttonLike.tag)
        }
    }
    
    @objc func commentTapped(_ sender: UITapGestureRecognizer) {
        
        UIView.transition(with: imageComment,
                          duration: 0.25,
                          options: .transitionFlipFromLeft,
                          animations: {
                            self.imageComment.image = UIImage(named:"comment")
        })
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageWidth = imageNew.frame.width
        let scale = imageWidth * 0.6
        let originY = imageNew.frame.origin.y
        
        UIView.animate(withDuration: 0.2, animations: {
            self.imageNew.bounds = CGRect(x: scale / 2 , y: originY + scale / 2, width: scale, height: scale)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.7,
                           options: [],
                           animations: {
                            self.imageNew.bounds = CGRect(x: 0, y: originY, width: imageWidth, height: imageWidth)
            })
        })
    }
    
    
    
}
