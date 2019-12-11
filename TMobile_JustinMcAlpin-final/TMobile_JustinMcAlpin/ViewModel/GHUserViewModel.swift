//
//  GHUserViewModel.swift
//  TMobile_JustinMcAlpin
//
//  Created by Consultant on 11/18/19.
//  Copyright © 2019 JustinMcAlpin. All rights reserved.
//

import Foundation

protocol GHUserViewModelProtocol
{
    var user: User { get }
    var repos: [Repo] { get }
    var details: UserDetailInfo? { get }
    func bind(_ update: @escaping UpdateHandler)
    func bindAndFire(_ update: @escaping UpdateHandler)
    func bindDetails(_ update: @escaping UpdateHandler)
    func bindDetailsAndFire(_ update: @escaping UpdateHandler)
    func unbind()
    func searchRepos(_ name: String)
    func image(for user: User, _ completion: @escaping ImageHandler)
    func getDetailsIfNeeded()
    
}

class GHUserViewModel: GHUserViewModelProtocol
{
    let user: User
    var currWorkItem: DispatchWorkItem!
    let queue: DispatchQueue = .global(qos: .userInitiated)
    let service: NetworkServiceProtocol
    var details: UserDetailInfo?
    var repos: [Repo] = []
    {
        didSet
        {
            update?()
        }
    }
    var update: UpdateHandler?
    var dUpdate: UpdateHandler?
    
    init(user: User, networkService: NetworkServiceProtocol)
    {
        self.user = user
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
    
    func bindDetails(_ update: @escaping UpdateHandler)
    {
        dUpdate = update
    }
    
    func bindDetailsAndFire(_ update: @escaping UpdateHandler)
    {
        dUpdate = update
        update()
    }
    
    func unbind() {
        update = nil
        dUpdate = nil
    }
    
    func searchRepos(_ name: String)
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
                self.searchReposHelper(name)
        }
        queue.asyncAfter(deadline: .now() + 0.4, execute: currWorkItem)
    }
    
    func searchReposHelper(_ name: String)
    {
        let urlString = GHConstants.userRepoSearch(name, user: user.login)
        service.startUniqueTask(type: RepoSearchResponse.self, urlString: urlString) { (result) in
            self.repos = result?.items ?? []
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
    
    func getDetailsIfNeeded()
    {
        if details != nil
        {
            return
        }
        service.startTask(type: UserDetailInfo.self, urlString: user.url)
        {
            (result) in
            self.details = result
        }
    }

}
