//
//  Model.swift
//  Xfinity_JustinMcAlpin
//
//  Created by Consultant on 11/18/19.
//  Copyright © 2019 JustinMcAlpin. All rights reserved.
//

import Foundation

class Model: Codable
{
    struct characterIcon: Codable
    {
        let Height: String
        let Width: String
        let URL: String
    }
    
    struct character : Codable
    {
        let Result: String
        let FirstURL: String
        let Text: String
        let Icon: characterIcon
    }
    
    struct database: Codable
    {
        let RelatedTopics: [character]
    }
}
