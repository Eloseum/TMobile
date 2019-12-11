//
//  UserTableViewCell.swift
//  TMobile_JustinMcAlpin
//
//  Created by Consultant on 11/18/19.
//  Copyright © 2019 JustinMcAlpin. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell
{
    static let identifier = "TableViewCell"
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
}
