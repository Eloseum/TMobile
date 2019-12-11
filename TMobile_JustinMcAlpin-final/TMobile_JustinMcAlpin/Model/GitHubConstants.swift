//
//  GitHubConstants.swift
//  TMobile_JustinMcAlpin
//
//  Created by Consultant on 11/18/19.
//  Copyright © 2019 JustinMcAlpin. All rights reserved.
//

import Foundation

enum GHConstants {
    static let userSearch = "https://api.github.com/search/users?q="
    static func userRepoSearch(_ query: String, user: String) -> String {
        "https://api.github.com/search/repositories?q=\(query)+user:\(user)"
    }
}


