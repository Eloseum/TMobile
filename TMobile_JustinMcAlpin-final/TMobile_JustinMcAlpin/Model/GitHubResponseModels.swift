//
//  GitHubResponseModels.swift
//  TMobile_JustinMcAlpin
//
//  Created by Consultant on 12/11/19.
//  Copyright © 2019 JustinMcAlpin. All rights reserved.
//

import Foundation

struct UserResponse: Codable
{
    let items: [User]    
}

class User: Codable
{
    let login: String
    let id: Int
    let avatarUrl: String
    let url: String
    let reposUrl: String
    var repoCount: Int = 0
    
    enum CodingKeys: String, CodingKey
    {
        case login, id, url
        case avatarUrl = "avatar_url"
        case reposUrl = "repos_url"
    }
}

struct RepoResponse: Codable
{
    let count: Int
    
    enum CodingKeys: String, CodingKey
    {
        case count = "public_repos"
    }
}

struct UserDetailInfo: Codable
{
    var email: String?
    var location: String?
    var joinDate: String?
    var followers: Int
    var following: Int
    var bio: String?
}

struct RepoSearchResponse: Codable
{
    let items: [Repo]
}

struct Repo: Codable
{
    let id: Int
    let name: String
    let forkCount: Int
    let starCount: Int
    
    enum CodingKeys: String, CodingKey
    {
        case id, name
        case forkCount = "forks_count"
        case starCount = "stargazers_count"
    }
}
