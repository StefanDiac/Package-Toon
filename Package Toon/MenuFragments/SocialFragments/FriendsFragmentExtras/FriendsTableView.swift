//
//  FriendsTableView.swift
//  Package Toon
//
//  Created by Air_Book on 6/30/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import UIKit

class FriendsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var friendEntries: [(String,String)]
    
    init(frame: CGRect, style: UITableViewStyle, friendEntries friends: [(String, String)]) {
        friendEntries = friends
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor(red: 0.189, green: 0.345, blue: 0.384, alpha: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FriendTableCell.self))! as! FriendTableCell
        cell.friendCode.text = friendEntries[indexPath.row].0
        cell.friendName.text = friendEntries[indexPath.row].1
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You have selected the friend with the ID \(friendEntries[indexPath.row])")
    }
    
    func removeFriend(withCode code: String) {
        var removalCompleted = false
        for i in 0..<friendEntries.count {
            if !removalCompleted, friendEntries[i].0 == code  {
                friendEntries.remove(at: i)
                removalCompleted = true
            }
        }
        reloadData()
    }
}
