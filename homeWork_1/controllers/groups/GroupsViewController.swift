//
//  MyGroupsViewController.swift
//  homeWork_1
//
//  Created by Admin on 01.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
//    private var groups = [VkGroup]()
//    private var filteredGroups = [VkGroup]()
    
    //неюзаемая штука для показа возможностей
    private var groups: Results<VkGroup>?
    private var filteredGroups: Results<VkGroup>?
    private var notificationTokenGroups: NotificationToken?
    private var notificationTokenSearchGroups: NotificationToken?
    
    var searchActive = false
    
    var selectedRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.title = "Группы"
        setTableViewSettings()
        setSearchBarSettings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMyGroups()
        setObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObserver()
    }
    
    
    private func setTableViewSettings() {
//        tableView.delegate = self
//        tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    private func setSearchBarSettings() {
        searchBar.delegate = self
    }
    
    
    private func setObserver() {
        groups = RealmWorker.instance.getItems(VkGroup.self)?.sorted(byKeyPath: "name")
        notificationTokenGroups = self.groups?.observe { changes in
            print("groupObserver is work")
            switch changes {
               
            case .initial(let collection):
//                print(collection)
                self.tableView.reloadData()
                break
            case .update(let collection, let deletions, let insertions, let modifications):
                if !self.searchActive {
//                    self.tableView.beginUpdates()
//                    if deletions.count > 0 {
//                        self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
//                    }
//                    if modifications.count > 0 {
//                        self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
//                    }
//                    if insertions.count > 0 {
//                        self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
//                    }
//                    self.tableView.endUpdates()
//                    self.tableView.reloadData()
                }
//                print(collection)
//                print(deletions)
//                print(insertions)
//                print(modifications)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func removeObserver() {
        notificationTokenGroups = nil
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
}

extension GroupsViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchActive {
            searchActive = false
            tableView.reloadData()
            self.view.endEditing(true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Подумать над переделкой
        searchActive = (searchBar.text?.count)! > 0 ? true:false
        tableView.reloadData()
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
        if searchText == "" {
            searchActive = false
            getMyGroups()
        } else {
            searchActive = true
            getGroups(by: searchText)
        }
    }
}

extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filteredGroups?.count ?? 0 : groups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as! MyGroupCell
        let group = searchActive ? filteredGroups?[indexPath.row] : groups?[indexPath.row]
        if let group = group {
            cell.load(group)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let row = editActionsForRowAt.row
        let group = searchActive ? filteredGroups?[row] : groups?[row]
        if let group = group {
            let isMember = group.is_member > 0
            let leaveJoin = UITableViewRowAction(style: .normal, title: isMember ? "Покинуть":"Вступить") { action, index in
                let gid = group.gid
                let name = group.name
                self.groupSelected(gid: gid, name: name, isMember: isMember)
            }
            leaveJoin.backgroundColor = isMember ? .red : UIColor.vkColor.main
            return [leaveJoin]
        }
        return [UITableViewRowAction()]
    }
    
    func groupSelected(gid: Int, name: String, isMember: Bool) {
        let alert = UIAlertController(title: name, message: isMember ? "Вы действительно хотите покинуть группу?":"Вы действительно хотите вступить в эту группу?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: isMember ? "Покинуть":"Вступить", style: .default, handler: { action in
            isMember ? self.leaveGroup(by: gid) : self.joinGroup(by: gid)
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

//MARK: - Network funcs
extension GroupsViewController {
    
    private func getMyGroups() {
        AlamofireService.instance.getGroups(delegate: self)
    }
    
    private func getGroups(by search: String) {
        filteredGroups = RealmWorker.instance.getItems(VkGroup.self)?.filter("name contains[c] '\(search)'").sorted(byKeyPath: "name")
        tableView.reloadData()

//        notificationTokenSearchGroups = self.filteredGroups?.observe { changes in
//            print("groupObserver is work")
//            switch changes {
//            case .initial(_):
//                break
//            case .update(let collection, let deletions, let insertions, let modifications):
//                if self.searchActive {
////                    self.tableView.beginUpdates()
////                    if deletions.count > 0 {
////                    self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
////                    }
////                    if modifications.count > 0 {
////                        self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
////                    }
////                    if insertions.count > 0 {
////                        self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
////                    }
////                    self.tableView.endUpdates()
//                    self.tableView.reloadData()
//                }
//            case .error(let error):
//                print(error.localizedDescription)
//            }
//        }
//        tableView.reloadData()
    }
    
    private func leaveGroup(by gid: Int) {
        AlamofireService.instance.leaveGroup(gid: gid, delegate: self)
    }
    
    private func joinGroup(by gid: Int) {
        AlamofireService.instance.joinGroup(gid: gid, delegate: self)
    }
}

extension GroupsViewController: VkApiGroupsDelegate {
    
    func returnJoin(_ gid: Int) {}
    func returnJoin(_ error: String) {}
    func returnLeave(_ error: String) {}
    
    func returnLeave(_ gid: Int) {
        if let groups = groups {
            for  group in groups {
                if group.gid == gid {
                    FirebaseService.instance.removeGroup(group: group)
                    RealmWorker.instance.removeItem(group)
                    tableView.reloadData()
                    break
                }
            }
        }
//        tableView.reloadData()

    }
    
    
    private func deleteGroup(gid: Int, index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: .top)
    }
    
    
    func returnGroups(_ groups: [VkGroup]) {}
    
}



