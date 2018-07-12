//
//  DetailsPhoto.swift
//  Test
//
//  Created by v.sova on 12.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//

import Foundation

class DetailsPhoto {
    
    let likes: Int
    let downloads: Int
    let views: Int
    
    init(_ statistic: [String: AnyObject]) {
        
        guard let l = statistic["likes"] as? [String: AnyObject],
            let d = statistic["downloads"] as? [String: AnyObject],
            let v = statistic["views"] as? [String: AnyObject] else {
                
                likes = 0
                downloads = 0
                views = 0
                return
        }
                
        likes = l["total"] as? Int ?? 0
        downloads = d["total"] as? Int ?? 0
        views = v["total"] as? Int ?? 0
    }
}
