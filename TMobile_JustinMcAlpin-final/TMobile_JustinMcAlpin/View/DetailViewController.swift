//
//  DetailViewController.swift
//  TMobile_JustinMcAlpin
//
//  Created by Consultant on 11/18/19.
//  Copyright © 2019 JustinMcAlpin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{
    @IBOutlet weak var detailImage: UIImageView!

    var vm: GHUserViewModelProtocol!
    var user: User
    {
        vm.user
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = user.login
        vm.bindAndFire
        {
            DispatchQueue.main.async
            {
                [weak self] in
                let s = IndexSet(integer: 1)
                self?.tableView.reloadSections(s, with: .automatic)
            }
        }
        vm.bindDetailsAndFire
        {
            DispatchQueue.main.async
            {
                [weak self] in
                let s = IndexSet(integer: 0)
                self?.tableView.reloadSections(s, with: .automatic)
            }
        }
        vm.getDetailsIfNeeded()
    }

}

extension DetailViewController: UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 1
        {
            return vm.repos.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailTableViewCell.identifier, for: indexPath) as! UserDetailTableViewCell
            cell.delegate = self
            setupImage(user: user, imageView: cell.avatarImageView)
            let details = vm.details
            cell.userNameLabel.text = user.login
            cell.emailLabel.text = details?.email ?? "n/a"
            cell.locationLabel.text = details?.location ?? "n/a"
            cell.joinDateLabel.text = details?.joinDate  ?? "n/a"
            cell.followersLabel.text = (details?.followers.string ?? "0") + " Followers"
            cell.followingLabel.text = "Following " + (details?.following.string ?? "0")
            cell.biographyLabel.text = details?.bio ?? "n/a"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoInfoTableViewCell.identifier, for: indexPath) as! RepoInfoTableViewCell
        let repo = vm.repos[indexPath.row]
        cell.repoNameLabel.text = repo.name
        cell.forkLabel.text = repo.forkCount.string + " Forks"
        cell.starLabel.text = repo.starCount.string + " Stars"
        return cell
    }
    
    private func setupImage(user: User, imageView: UIImageView) {
        vm.image(for: user)
        {
            (imData) in
            DispatchQueue.main.async
            {
                if let imData = imData
                {
                    imageView.image = UIImage(data: imData)
                }
                else
                {
                    imageView.image = .qMark
                }
            }
        }
    }
    
}

extension DetailViewController: UserDetailSearchDelegate
{
    func search(_ name: String)
    {
        vm.searchRepos(name)
    }
    
}
