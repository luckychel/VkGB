//
//  FriendInfoViewController.swift
//  homeWork_1
//
//  Created by User on 30.09.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class FriendInfoViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var friend = VkFriend()
    var photos = [VkPhoto]()
    
    private var selectedImage = 0
    var bySwipe = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewSettings()
        parseFriend()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.vkColor.main
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    private func setCollectionViewSettings() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    private func parseFriend() {
        self.navigationItem.title = friend.last_name + " " + friend.first_name
        AlamofireService.instance.getPhotosBy(friend.uid, delegate: self)
    }
    

}

extension FriendInfoViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showImages") {
            let upcoming: ImagesViewController = segue.destination as! ImagesViewController
            upcoming.selectedImage = selectedImage
            upcoming.bySwipe = bySwipe
            upcoming.photos = photos
        }
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    private func showSwipeAlert() {
        let alert = UIAlertController(title: "Как хотите управлять изображениями?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Свайпами", style: .default, handler: { action in
            self.bySwipe = true
            self.performSegue(withIdentifier: "showImages", sender: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Интерактивно", style: .default, handler: { action in
            self.bySwipe = false
            self.performSegue(withIdentifier: "showImages", sender: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
}

extension FriendInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCollectionViewCell", for: indexPath) as! FriendCollectionViewCell
        cell.setImage(photos[indexPath.row].photoBig)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = indexPath.row
        collectionView.deselectItem(at: indexPath, animated: true)
        showSwipeAlert()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width/3.0
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension FriendInfoViewController: VkApiPhotosDelegate {
    
    func returnPhotos(_ photos: [VkPhoto]) {
        self.photos = photos
        collectionView.reloadData()
    }
    
}
