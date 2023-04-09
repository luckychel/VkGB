//
//  FriendsViewController.swift
//  homeWork_1
//
//  Created by User on 30.09.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import RealmSwift

protocol FriendsViewControllerDelegate {
    
    func selectTitle(title: String)
}

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customControll: CustomControl!
    @IBOutlet weak var searchBar: CustomSearchBar!

    var searchActive = false
    
    private var selectedSection = -1
    private var selectedRow = -1
    
    private var groupedFriends = [FriendList]()
    private var filteredGroupedFriends = [FriendList]()
    
    private var friends = [VkFriend]()
    private var friendsViewModel = [FriendViewModel]()
    
    private let friendsApapter = FriendsAdapter()
    private let factory = FriendViewModelFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewSettings()
        getFriends()
        setCustomView()
        setSearchBarSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    private func setTableViewSettings() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    private func setGroupedFriend(_ friends: [VkFriend]) {
        GlobalConstants.titles.removeAll()
        var groupedFriend = FriendList()
        
        //self.friendsViewModel = factory.constructViewModels(friends: friends)

        for friend in friends {
            //last_name->full_name
            if groupedFriend.title != friend.full_name.prefix(1) {
                GlobalConstants.titles.append(String(friend.full_name.prefix(1)))
                if (groupedFriend.title.count != 0) {
                    groupedFriends.append(groupedFriend)
                    groupedFriend = FriendList()
                }
                groupedFriend.title = String(friend.full_name.prefix(1))
            }
            groupedFriend.friends.append(friend)
        }
        groupedFriends.append(groupedFriend)
        
    }
    
    
    private func setCustomView() {
        customControll.delegate = self
        customControll.setupView()
    }
    
    
    private func setSearchBarSettings() {
        searchBar.delegate = self
        searchBar.setSubViews(width: self.view.frame.width)
    }
    

}

extension FriendsViewController {
    
    //MARK: - Network funcs
    private func getFriends() {
        //AlamofireService.instance.getFriends(delegate: self)
        
        friendsApapter.getFriends {[weak self] result in
            guard let self = self else { return }
            self.returnFriends(result)
        }
    }
}

extension FriendsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showFriend") {
            let upcoming:FriendInfoViewController = segue.destination as! FriendInfoViewController
            upcoming.friend = searchActive ? filteredGroupedFriends[selectedSection].friends[selectedRow] : groupedFriends[selectedSection].friends[selectedRow]
        }
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
}

extension FriendsViewController: CustomSearchBarDelegate {
    
    func textChanged(text: String) {
        if text == "" {
            searchActive = false
        } else {
            searchActive = true
            filteredGroupedFriends.removeAll()
            for group in groupedFriends {
                let filteredFriends = group.friends.filter{$0.first_name.lowercased().contains(text.lowercased()) || $0.last_name.lowercased().contains(text.lowercased())}
                if filteredFriends.count > 0 {
                    let filterGroup = FriendList()
                    filterGroup.title = group.title
                    filterGroup.friends = filteredFriends
                    filteredGroupedFriends.append(filterGroup)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func cancelSearch() {
        searchActive = false
        tableView.reloadData()
        self.view.endEditing(true)
    }
    
    
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        customControll.isHidden = searchActive
        return searchActive ? filteredGroupedFriends.count : groupedFriends.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filteredGroupedFriends[section].friends.count : groupedFriends[section].friends.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendHeaderTableViewCell") as! FriendHeaderTableViewCell
        let friendGroup = searchActive ? filteredGroupedFriends[section] : groupedFriends[section]
        cell.labelTitle.text = friendGroup.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        let friend = searchActive ? filteredGroupedFriends[indexPath.section].friends[indexPath.row] : groupedFriends[indexPath.section].friends[indexPath.row]
        var viewModel = factory.viewModel(friend: friend)
        cell.configure(friend: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        selectedSection = indexPath.section
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showFriend", sender: nil)
    }
    
}

extension FriendsViewController: FriendsViewControllerDelegate {
    
    func selectTitle(title: String) {
        for (index, char) in GlobalConstants.titles.enumerated() {
            if char == title {
                print ("Select section \(index)")
                let indexPath = IndexPath(row: NSNotFound, section: index)
                tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                break
            }
        }
    }
    
    
}

extension FriendsViewController: VkApiFriendsDelegate {
    
    func returnFriends(_ friends: [VkFriend]) {
        setGroupedFriend(friends)
        tableView.reloadData()
    }
    
}




