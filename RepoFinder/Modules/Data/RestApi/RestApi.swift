//
//  RestApi.swift
//  RepoFinder
//
//  Created by Konstantin Efimenko on 9/12/17.
//  Copyright © 2017 Konstantin Efimenko. All rights reserved.
//

import Foundation

class RestApi {

    func getRepositories(pattern: String, success:@escaping ([String])->(), fail:@escaping ()->()) {

        let urlComp = NSURLComponents(string: "https://api.github.com/search/repositories")!
        urlComp.queryItems = [URLQueryItem(name: "q", value: pattern)]
        let session = URLSession.shared
        var request = URLRequest(url: urlComp.url!)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil, let data = data else {
                fail()
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    guard let content = json["items"] as? [[String : Any]] else {
                        print("Can't cast JSON")
                        return
                    }
                    let result = content.flatMap({$0["name"] as? String})
                    success(result)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
}
