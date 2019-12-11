//
//  UserDetailTableViewCell.swift
//  TMobile_JustinMcAlpin
//
//  Created by Consultant on 11/18/19.
//  Copyright © 2019 JustinMcAlpin. All rights reserved.
//

import UIKit

protocol UserDetailSearchDelegate
{
    func search(_ name: String)
}

class UserDetailTableViewCell: UITableViewCell
{    
    static let identifier = "UserDetailTableViewCell"
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var joinDateLabel: UILabel!
    @IBOutlet var followersLabel: UILabel!
    @IBOutlet var followingLabel: UILabel!
    @IBOutlet var biographyLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    {
        didSet
        {
            searchBar.delegate = self
        }
    }
    
    var delegate: UserDetailSearchDelegate?
}

extension UserDetailTableViewCell: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.isEmpty == false
        {
            delegate?.search(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = ""
    }
}

