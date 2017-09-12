//
//  ArchiveService.swift
//  RepoFinder
//
//  Created by Konstantin Efimenko on 9/12/17.
//  Copyright © 2017 Konstantin Efimenko. All rights reserved.
//

import Foundation

class ArchiveService {

    func addToSaved(_ value: String, key:String) {
        if let itemsObjects = UserDefaults.standard.array(forKey: key) as? [String]{
            var items = itemsObjects
            if let index = items.index(of:value){
                items.remove(at: index)
            }
            items.append(value)
            UserDefaults.standard.set(items, forKey: key)
        } else {
            UserDefaults.standard.set([value], forKey: key)
        }
    }

    func getHistory(key: String) -> [String]{
        let result = UserDefaults.standard.array(forKey: key) as? [String] ?? [String]()
        return result.reversed()
    }

}
