//
//  RepoInfoTableViewCell.swift
//  TMobile_JustinMcAlpin
//
//  Created by Consultant on 11/18/19.
//  Copyright © 2019 JustinMcAlpin. All rights reserved.
//

import UIKit

class RepoInfoTableViewCell: UITableViewCell
{
    static let identifier = "RepoInfoTableViewCell"
    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
}
