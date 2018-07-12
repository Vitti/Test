//
//  Extensions.swift
//  Test
//
//  Created by v.sova on 11.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//

import Foundation

extension String {
    
    func getDateInSec() -> Double {
        
        let dateFormater = DateFormatter.init()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormater.date(from: self) else {
            return 0
        }
        
        return date.timeIntervalSince1970
    }
}
