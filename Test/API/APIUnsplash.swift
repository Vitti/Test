//
//  APIUnsplash.swift
//  Test
//
//  Created by v.sova on 05.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//

import Foundation
import Alamofire

let cServer = "https://unsplash.com/oauth/authorize"

class APIUnsplash {
    
    class func autorization() {
        
        UIApplication.shared.open(URL.init(string: "https://unsplash.com/oauth/authorize?client_id=9417a72a347dc86d1e80f67d9f4a16fabc269159380d7826e5954ee74a589810&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&scope=public+read_user")!, options: [:]) { (isOK) in
            
            
        }
    }
    
    class func login(_ code: String) {
        
        let parameters: [String: AnyObject] = [
        
            "client_id": "9417a72a347dc86d1e80f67d9f4a16fabc269159380d7826e5954ee74a589810" as AnyObject,
            "client_secret": "09de7aca93a6e12be402013531af19ba51287108695f04b51d1f355c7af9ba50" as AnyObject,
            "redirect_uri": "urn:ietf:wg:oauth:2.0:oob" as AnyObject,
            "code": code as AnyObject,
            "grant_type": "authorization_code" as AnyObject
        ]
        
        Alamofire.request(URL.init(string: "https://unsplash.com/oauth/token")!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
                
            case .success(let value):
                print(value)
                
            case .failure(let err):
                print(err)
            }
        }
    }
}
