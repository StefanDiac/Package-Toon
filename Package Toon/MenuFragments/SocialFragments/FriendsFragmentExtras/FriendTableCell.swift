//
//  FriendTableCell.swift
//  Package Toon
//
//  Created by Air_Book on 7/1/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import UIKit

class FriendTableCell: UITableViewCell {
    let padding: CGFloat = 5
    var friendName: UILabel!
    var friendCode: UILabel!
    var removeFriendButton: UIButton!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .gray
        self.backgroundColor = UIColor(red: 0.189, green: 0.345, blue: 0.384, alpha: 1)
        
        friendName = UILabel(frame: CGRect.zero)
        friendName.textAlignment = .left
        friendName.textColor = .white
        friendName.font = UIFont(name: "AvenirNext-Heavy", size: 24)
        contentView.addSubview(friendName)
        
        friendCode = UILabel(frame: CGRect.zero)
        friendCode.textAlignment = .center
        friendCode.textColor = .white
        friendCode.font = UIFont(name: "AvenirNext-Heavy", size: 24)
        contentView.addSubview(friendCode)
        
        removeFriendButton = UIButton(frame: CGRect.zero)
        removeFriendButton.setImage(UIImage(named: "cancelButton"), for: .normal)
        removeFriendButton.addTarget(self, action: #selector(handleRemoveFriendTap), for: UIControlEvents.touchUpInside)
        removeFriendButton.imageView?.contentMode = .scaleAspectFit
        
        contentView.addSubview(removeFriendButton)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendCode.text = nil
        friendName.text = nil
        removeFriendButton.imageView?.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        friendName.frame =  CGRect(x: padding, y: 0, width: frame.width/3, height: frame.height)
        friendCode.frame =  CGRect(x: friendName.frame.maxX + padding, y: 0, width: frame.width/3, height: frame.height)
        removeFriendButton.frame = CGRect(x: frame.width - padding - 35, y: 7, width: 35, height: 35)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @objc func handleRemoveFriendTap() {
        removeFriend(withCode: friendCode.text)
    }
    
    func removeFriend(withCode code: String?) {
        if let friendCode = code {
            print(friendCode)
            let tableView = superview as? FriendsTableView
            if let table = tableView {
                FirebaseDAO.removeFriend(withCode: friendCode, forTableToUpdate: table)
            }
        }
    }
}
