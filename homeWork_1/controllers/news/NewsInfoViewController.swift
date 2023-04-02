//
//  NewsInfoViewController.swift
//  homeWork_1
//
//  Created by Admin on 11/28/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class NewsInfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var feed = VkFeed()
    var comments = [VkComment]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewSettings()
        prepareGetComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    private func setTableViewSettings() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    private func prepareGetComments() {
        AlamofireService.instance.getComments(ownerId: feed.sourceId, postId: feed.feedId, delegate: self)
    }
    

//    private func setImages() {
//        scrollVIewHeightConstraint.constant = scrollViewImages.frame.width / 2
//
//        let scrollHeight = scrollViewImages.frame.width / 2
//
//        var contentSize: CGFloat = 0
//        for (index, attachment) in feed.attachments.enumerated() {
//            let imageHeight = scrollHeight
//            let imageWidth = imageHeight * CGFloat(attachment.width) / CGFloat(attachment.height)
//            let imageView = UIImageView.init(frame: CGRect(x: contentSize + 2, y: 0, width: imageWidth, height: imageHeight))
//            imageView.tag = index
//            imageView.isUserInteractionEnabled = true
//            imageView.contentMode = UIViewContentMode.scaleAspectFill
//            imageView.clipsToBounds = true
//            scrollViewImages.addSubview(imageView)
//            imageView.sd_setImage(with: URL(string: attachment.imageUrl), placeholderImage: UIImage(named: "noPhoto"))
//            contentSize += imageWidth + 2
//        }
//        scrollViewImages.contentSize.width = contentSize + 2
//
//    }
    

}

extension NewsInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsInfoTableViewCell", for: indexPath) as! NewsInfoTableViewCell
            cell.load(feed: feed)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            cell.load(comments[indexPath.row])
            return cell
        }
        
    }
    
}

extension NewsInfoViewController: VkApiCommentsDelegate {
    
    func returnComments(_ comments: [VkComment]) {
        self.comments.removeAll()
        self.comments.append(contentsOf: comments)
        tableView.reloadData()
    }
}
