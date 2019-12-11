//
//  ViewModelFactory.swift
//  TMobile_JustinMcAlpin
//
//  Created by Consultant on 11/18/19.
//  Copyright © 2019 JustinMcAlpin. All rights reserved.
//

import Foundation

typealias UpdateHandler = ()->Void

final class ViewModelFactory {
    
    static let shared = ViewModelFactory()
    let networkService: NetworkServiceProtocol = NetworkService()
    
    private init() { }
    
    func makeGitHubViewModel() -> GitHubViewModel
    {
        return GitHubViewModel(networkService: networkService)
    }
    
    func makeGHUserViewModel(_ user: User) -> GHUserViewModel
    {
        return GHUserViewModel(user: user, networkService: networkService)
    }
    
}

