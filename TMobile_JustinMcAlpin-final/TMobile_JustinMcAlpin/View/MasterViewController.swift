//
//  MasterViewController.swift
//  TMobile_JustinMcAlpin
//
//  Created by Consultant on 11/18/19.
//  Copyright © 2019 JustinMcAlpin. All rights reserved.
//

import UIKit



class MasterViewController: UIViewController
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var vm: GitHubViewModelProtocol = {
       ViewModelFactory.shared.makeGitHubViewModel()
    }()
    
    var detailViewController: DetailViewController? = nil

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let split = self.splitViewController
        {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        vm.bindAndFire {
            DispatchQueue.main.async
            {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showDetail"
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                let user = vm.users[indexPath.row]
                controller.vm = ViewModelFactory.shared.makeGHUserViewModel(user)
            }
        }
    }

}

extension MasterViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return vm.users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        let user = vm.users[indexPath.row]
        cell.nameLabel.text = user.login
        setupCount(user: user, label: cell.countLabel)
        setupImage(user: user, imageView: cell.detailImage)
        return cell
        
    }
    
    private func setupImage(user: User, imageView: UIImageView)
    {
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
    
    private func setupCount(user: User, label: UILabel)
    {
        vm.fetchRepoCount(for: user)
        {
            (_) in
            DispatchQueue.main.async
            {
                label.text = user.repoCount.string
            }
        }
    }
    
}

extension MasterViewController: UITableViewDelegate
{
}

extension MasterViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if !searchText.isEmpty
        {
            vm.search(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = ""
    }
}

