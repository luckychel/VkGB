//
//  NewsTableViewCell.swift
//  homeWork_1
//
//  Created by User on 30.09.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SDWebImage

protocol NewsTableViewCellDelegate {
    func changeLike(row: Int)
}

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewIconContainer: UIView!
    @IBOutlet weak var imageViewGroup: UIImageView!
    @IBOutlet weak var labelFeedGroupHeader: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var imageNew: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var bottomSeparator: UIView!
    
    @IBOutlet weak var stackLikes: UIStackView!
    @IBOutlet weak var stackComments: UIStackView!
    @IBOutlet weak var stackReposts: UIStackView!
    @IBOutlet weak var stackViews: UIStackView!
    
  
    @IBOutlet weak var imageViewLike: UIImageView!
    @IBOutlet weak var labelLike: UILabel!
    
    @IBOutlet weak var imageViewComment: UIImageView!
    @IBOutlet weak var labelComment: UILabel!
    
    @IBOutlet weak var imageViewShare: UIImageView!
    @IBOutlet weak var labelShare: UILabel!
    
    @IBOutlet weak var imageViewViews: UIImageView!
    @IBOutlet weak var labelViews: UILabel!
    
    
    var delegate: NewsTableViewCellDelegate?
    
    var operation: SDWebImageOperation!
    
    
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
        
        imageNew.image = nil
        
        if operation != nil {
            operation.cancel()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewIconContainer.pin.top(10).left(15).size(60)
        imageViewGroup.pin.all()
        
        labelFeedGroupHeader.pin.after(of: viewIconContainer)
            .top(15).right(0).height(25).marginHorizontal(15).sizeToFit(.width)
        labelDate.pin.below(of: labelFeedGroupHeader, aligned: .left)
            .width(of: labelFeedGroupHeader).sizeToFit(.width).marginTop(10)
        
        //image with text
        imageNew.pin.below(of: viewIconContainer)
            .left(0).right(0).marginTop(10)
        labelText.pin.below(of: imageNew)
            .left(16).right(16)
            .marginTop(8).marginBottom(8)
        
        //buttons
        let widthButton = self.frame.size.width * 21 / 100
        let widthViews = self.frame.size.width * 30 / 100
        stackLikes.pin.below(of: labelText)
            .left(10).width(widthButton).height(30)
        stackComments.pin.after(of: stackLikes, aligned: .top)
            .marginLeft(5).width(widthButton).height(30)
        stackReposts.pin.after(of: stackComments, aligned: .top)
            .marginLeft(5).width(widthButton).height(30)
        stackViews.pin.after(of: stackReposts, aligned: .top)
            .right(5).width(widthViews).height(30)
        
        //separator
        viewSeparator.pin.below(of: stackLikes)
            .left(0).right(0).bottom(0).height(10).pinEdges()
        bottomSeparator.pin
            .top(0).left(0).right(0).height(0.5)
    }
    
    
    func configure(feed: VkFeed) {
        
        labelDate.text = feed.getFeedDate()
        labelFeedGroupHeader.text = feed.sourceName
        
        if feed.feedText.count == 0 {
            labelText.pin.height(0)
        } else {
            labelText.pin.height(70)
        }
        
        labelText.text = feed.feedText
        labelLike.text = feed.getStringFrom(count: feed.countLikes)
        labelViews.text = feed.getStringFrom(count: feed.countViews)
        labelShare.text = feed.getStringFrom(count: feed.countReposts)
        labelComment.text = feed.getStringFrom(count: feed.countComments)
        
        imageViewGroup.sd_setImage(with: URL(string: feed.sourceUrl), placeholderImage: UIImage(named: "noPhoto"))
        
        if feed.attachments.count > 0 {
            
            let height = self.frame.width * CGFloat(feed.attachments[0].height) / CGFloat(feed.attachments[0].width)
            
            imageNew.pin.height(height)
            
            imageNew.sd_setImage(with: URL(string: feed.attachments[0].imageUrl), placeholderImage: UIImage(named: "noPhoto"))
            
        } else {
            imageNew.pin.height(0)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    

    

}


//MARK: - unused
extension NewsTableViewCell {
    
    //    private func setTaps() {
    //        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
    //        imageNew.addGestureRecognizer(imageTap)
    //
    //        let tap = UITapGestureRecognizer(target: self, action: #selector(self.likeTapped(_:)))
    //        buttonLike.addGestureRecognizer(tap)
    //
    //        let commentTap = UITapGestureRecognizer(target: self, action: #selector(self.commentTapped(_:)))
    //        imageComment.addGestureRecognizer(commentTap)
    //    }
    //
    //
    //    @objc func likeTapped(_ sender: UITapGestureRecognizer) {
    //        UIView.transition(with: buttonLike, duration: 0.25, options: buttonLike.isLiked ? .transitionFlipFromRight : .transitionFlipFromLeft, animations: {
    //            self.buttonLike.changeLike()
    //        })
    //        if let delegate = delegate {
    //            delegate.changeLike(row: buttonLike.tag)
    //        }
    //    }
    //
    //    @objc func commentTapped(_ sender: UITapGestureRecognizer) {
    //
    //        UIView.transition(with: imageComment,
    //                          duration: 0.25,
    //                          options: .transitionFlipFromLeft,
    //                          animations: {
    //                            self.imageComment.image = UIImage(named:"comment")
    //        })
    //    }
    //
    //    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
    //        let imageWidth = imageNew.frame.width
    //        let scale = imageWidth * 0.6
    //        let originY = imageNew.frame.origin.y
    //
    //        UIView.animate(withDuration: 0.2, animations: {
    //            self.imageNew.bounds = CGRect(x: scale / 2 , y: originY + scale / 2, width: scale, height: scale)
    //        }, completion: { _ in
    //            UIView.animate(withDuration: 0.5,
    //                           delay: 0,
    //                           usingSpringWithDamping: 0.5,
    //                           initialSpringVelocity: 0.7,
    //                           options: [],
    //                           animations: {
    //                            self.imageNew.bounds = CGRect(x: 0, y: originY, width: imageWidth, height: imageWidth)
    //            })
    //        })
    //    }
    
    
    private func prepareBlur() {
        // попытка сделать blur фотки,
        // а потом заанимировать на переход к нормальной фотке
        
        //            operation = SDWebImageManager.shared().loadImage(with: URL(string: feed.attachments[0].imageUrl), options: .highPriority, progress: nil, completed: {
        //                (image: UIImage?, data: Data?, error: Error?, cacheType: SDImageCacheType, finished: Bool, url: URL?) in
        //                if let image = image {
        //                    self.generateBlureImage(image)
        //                } else {
        //                    self.imageNew.image = UIImage(named: "noPhoto")
        //                }
        //            })
    }
    
    
    private func generateBlureImage(_ image: UIImage) {
        DispatchQueue.global(qos: .userInteractive).async {
            let inputCIImage = CIImage(image: image)!
            let blurFilter = CIFilter(name: "CIGaussianBlur", parameters: [kCIInputImageKey: inputCIImage])!
            let outputImage = blurFilter.outputImage!
            let context = CIContext()
            
            let cgiImage = context.createCGImage(outputImage, from: outputImage.extent)
            let bluredImage = UIImage(cgImage: cgiImage!)
            self.animateImage(blur: bluredImage, origin: image)
        }
    }
    
    
    private func animateImage(blur: UIImage, origin: UIImage) {
        if operation != nil {
            DispatchQueue.main.async {
                self.imageNew.image = blur
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.transition(with: self.imageNew, duration: 0.2, options: .transitionCrossDissolve, animations: { self.imageNew.image = origin }, completion: nil)
            }
        }
    }

}
