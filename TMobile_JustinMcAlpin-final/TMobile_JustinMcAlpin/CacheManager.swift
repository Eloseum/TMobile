//
//  CacheManager.swift
//  GoogleBooks
//
//  Created by Justin McAlpin on 11/18/19.
//  Copyright © 2019 MobileAPPSCompany. All rights reserved.
//

import Foundation

typealias DataHandler = (Data?) -> Void
let cache = CacheManager.shared

final class CacheManager
{
    
    private let cache = NSCache<NSString, NSData>()
    
    static let shared = CacheManager()
    private init() {}
    
    
    func downloadFrom(endpoint: String, completion: @escaping DataHandler)
    {
        
        //1. check if the cache has the data
        if let data = cache.object(forKey: endpoint as NSString)
        {
            completion(data as Data)
            return
        }
        
        guard let url = URL(string: endpoint) else
        {
            completion(nil)
            return
        }
        
        //2. If not, create API Request
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            
            if let error = err
            {
                print("Bad Task: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = dat
            {
                
                //3. save data in cache for next time
                self.cache.setObject(data as NSData, forKey: endpoint as NSString)
                
                
                //4. pass back data through the completion
                DispatchQueue.main.async {
                    //back to main thread to pass completion
                    completion(data)
                }
            }
            
        }.resume()
    }
    
    
}
