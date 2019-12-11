//
//  GitHubViewModel.swift
//  TMobile_JustinMcAlpin
//
//  Created by Consultant on 11/18/19.
//  Copyright © 2019 JustinMcAlpin. All rights reserved.
//

import Foundation

protocol GitHubViewModelProtocol {
    var users: [User] { get }
    func bind(_ update: @escaping UpdateHandler)
    func bindAndFire(_ update: @escaping UpdateHandler)
    func unbind()
    func search(_ name: String)
    func image(for user: User, _ completion: @escaping ImageHandler)
    func fetchRepoCount(for user: User, _ completion: @escaping (Bool)->Void)
}

class GitHubViewModel: GitHubViewModelProtocol {
        
    var users: [User] = []
    {
        didSet
        {
            update?()
        }
    }
    
    var update: UpdateHandler?
    var currWorkItem: DispatchWorkItem!
    let queue: DispatchQueue = .global(qos: .userInitiated)
    let service: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        service = networkService
    }
    
    func bind(_ update: @escaping UpdateHandler)
    {
        self.update = update
    }
    func bindAndFire(_ update: @escaping UpdateHandler)
    {
        self.update = update
        update()
    }
    func unbind()
    {
        update = nil
    }
    func search(_ name: String)
    {
        currWorkItem?.cancel()
        service.currUniqueTask?.cancel()
        currWorkItem = DispatchWorkItem
            {
                [weak self] in
                guard let self = self else
                {
                    return
                }
                self.searchHelper(name)
        }
        queue.asyncAfter(deadline: .now() + 0.4, execute: currWorkItem)
    }

    private func searchHelper(_ name: String)
    {
        service.startUniqueTask(type: UserResponse.self, urlString: GHConstants.userSearch + name)
        {
            (result) in
            guard let result = result else
            {
                return
            }
            self.users = result.items
        }
    }
    
    func fetchRepoCount(for user: User, _ completion: @escaping (Bool)->Void)
    {
        completion(false)
        guard user.repoCount < 1 else
        {
            return
        }
        service.startTask(type: RepoResponse.self, urlString: user.url)
        {
            (response) in
            var success = false
            defer
            {
                completion(success)
            }
            if let response = response
            {
                user.repoCount = response.count
                success = true
            }
        }
    }
    
    func image(for user: User, _ completion: @escaping ImageHandler)
    {
        completion(nil)
        service.fetchImage(urlString: user.avatarUrl)
        {
            (data) in
            completion(data)
        }
    }
}


