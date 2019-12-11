//
//  NetworkService.swift
//  TMobile_JustinMcAlpin
//
//  Created by Consultant on 11/18/19.
//  Copyright © 2019 JustinMcAlpin. All rights reserved.
//

import Foundation

typealias ImageHandler = (Data?)->Void

protocol NetworkServiceProtocol {
    
    /// reference to the currently-unique task, to cancel if desired
    var currUniqueTask: URLSessionDataTask! { get }
    
    /// for image downloads
    func fetchImage(urlString: String, completion: @escaping ImageHandler)
    
    /// for any task that you don't want several to be called of
    func startUniqueTask<T: Decodable>(type: T.Type, urlString: String, _ completion: @escaping (T?)->Void)
    
    /// for most other decodable tasks
    func startTask<T: Decodable>(type: T.Type, urlString: String, _ completion: @escaping (T?)->Void)
}

class NetworkService: NetworkServiceProtocol {
    
    var currUniqueTask: URLSessionDataTask!
    let session: URLSession = .init(configuration: .default)
    
    // TODO: Set up an image cache here
    func fetchImage(urlString: String, completion: @escaping ImageHandler) {
        
        guard let url = URL(string: urlString) else
        {
            completion(nil)
            return
        }
        session.dataTask(with: url)
        {
            (data, _ ,_) in
            completion(data)
        }
        .resume()
    }
    
    
    func startUniqueTask<T: Decodable>(type: T.Type, urlString: String, _ completion: @escaping (T?)->Void)
    {
        currUniqueTask?.cancel()
        guard let url = URL(string: urlString) else
        {
            completion(nil)
            return
        }
        currUniqueTask = session.dataTask(with: url)
        {
            (data, _ ,_) in
            guard let data = data else
            {
                return
            }
            do
            {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(response)
            }
            catch let err
            {
                print("startUniqueTask Error for \(url):", err)
            }
        }
        currUniqueTask.resume()
    }
    
    
    func startTask<T: Decodable>(type: T.Type, urlString: String, _ completion: @escaping (T?)->Void)
    {
        guard let url = URL(string: urlString) else
        {
            completion(nil)
            return
        }
        session.dataTask(with: url)
        {
            (data, _ ,_) in
            guard let data = data else
            {
                return
            }
            do
            {
                let decoder = JSONDecoder()
                let response = try decoder.decode(T.self, from: data)
                completion(response)
            }
            catch let err
            {
                print("startTask Error for \(url):", err)
            }
        }
        .resume()
    }
    
}


