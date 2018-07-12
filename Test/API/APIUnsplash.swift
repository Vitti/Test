//
//  APIUnsplash.swift
//  Test
//
//  Created by v.sova on 05.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa
import MagicalRecord

fileprivate let cAppAccessKey = "9417a72a347dc86d1e80f67d9f4a16fabc269159380d7826e5954ee74a589810"

enum Urls {

    case feedPhoto(per_page: Int, page: Int)
    case authorize
    case getAccessToken
    case getMe
    case like(id: String)
    case statistics(id: String)
    case userPhotos(userName: String, per_page: Int, page: Int)
    
    func urlString() -> String {
        
        switch self {
        case .feedPhoto(let per_page, let page):
            return "https://api.unsplash.com/photos/?client_id=" + cAppAccessKey + "&per_page=\(per_page)&page=\(page)"
        case .authorize:
            return "https://unsplash.com/oauth/authorize?client_id=\(cAppAccessKey)&redirect_uri=https://google.com&response_type=code&scope=public+read_user+write_user+read_photos+write_photos+write_likes+write_followers+read_collections+write_collections"
        case .getAccessToken:
            return "https://unsplash.com/oauth/token"
        case .getMe:
            return "https://api.unsplash.com/me"
        case .like(let id):
            return "https://api.unsplash.com/photos/\(id)/like"
        case .statistics(let id):
            return "https://api.unsplash.com/photos/\(id)/statistics"
        case .userPhotos(let userName, let per_page, let page):
            return "https://api.unsplash.com/users/\(userName)/photos&per_page=\(per_page)&page=\(page)"
        }
    }
}

class APIUnsplash {

    var dbManager: DBManager
    
    init(_ db: DBManager) {
        
        dbManager = db
    }
    
    func headers() -> HTTPHeaders? {
        
        var headers = ["Accept-Version": "v1"]
        if let token = UserViewModel.getAccessToken() {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
}

//MARK: - Authentication

extension APIUnsplash {
    
    func getToken(_ code: String) -> Observable<[String: Any]?> {
        
        let parameters: [String: AnyObject] = [
            
            "client_id": "9417a72a347dc86d1e80f67d9f4a16fabc269159380d7826e5954ee74a589810" as AnyObject,
            "client_secret": "09de7aca93a6e12be402013531af19ba51287108695f04b51d1f355c7af9ba50" as AnyObject,
            "redirect_uri": "https://google.com" as AnyObject,
            "code": code as AnyObject,
            "grant_type": "authorization_code" as AnyObject
        ]
        
        return json(.post, URL.init(string: Urls.getAccessToken.urlString())!, parameters: parameters, encoding: URLEncoding.default, headers: self.headers())
            .map({
                
                guard let data = $0 as? [String: AnyObject], let accessToken = data["access_token"] as? String else {
                    
                    return nil
                }
                UserViewModel.saveAccessToken(accessToken)
                return data
            }).catchError({ (error) -> Observable<[String : Any]?> in
                
                print(error.localizedDescription)
                return Observable.just([:])
            })
    }
    
    func getUser(_ token: String) -> Observable<[String: Any]?> {
        
        return json(.get, URL.init(string: Urls.getMe.urlString())!, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization": "Bearer " + token]).map({ value in
            
            guard let userDict = value as? [String: Any] else {
                return nil
            }
            
            self.dbManager.saveUser(userDict)
            
            return userDict
        })
    }
}

//MARK: - Public

extension APIUnsplash {
    
    func getFeedPhoto(_ per_page: Int, _ page: Int) -> Observable<[[String: AnyObject]]> {
        
        return json(.get, URL.init(string: Urls.feedPhoto(per_page: per_page, page: page).urlString())!, parameters: nil, encoding: URLEncoding.default, headers: self.headers()).map({ value in
            
            guard let photos = value as? [[String: AnyObject]] else {
                return []
            }
            
            self.dbManager.savePhotos(photos)
            
            return photos
            
        })
    }
}

//MARK: - Photos

extension APIUnsplash {
    
    func likePhoto(_ id: String) -> Observable<Bool> {
        
        return json(.post, URL.init(string: Urls.like(id: id).urlString())!, parameters: nil, encoding: URLEncoding.default, headers: self.headers()).map({ (value) in
            
            guard let data = value as? [String: AnyObject], var photo = data["photo"] as? [String: AnyObject] else {
                return false
            }
            
            photo["user"] = data["user"]
            
            self.dbManager.savePhotos([photo])
            
            return true
        })
    }
    
    func unlikePhoto(_ id: String) -> Observable<Bool> {
        
        return json(.delete, URL.init(string: Urls.like(id: id).urlString())!, parameters: nil, encoding: URLEncoding.default, headers: self.headers()).map({ (value) in
            
            guard let data = value as? [String: AnyObject], var photo = data["photo"] as? [String: AnyObject] else {
                return false
            }
            
            photo["user"] = data["user"]
            
            self.dbManager.savePhotos([photo])
            
            return true
        })
    }
    
    func statisticsPhoto(_ id: String) -> Observable<[String: AnyObject]> {
        
        return json(.get, URL.init(string: Urls.statistics(id: id).urlString())!, parameters: nil, encoding: URLEncoding.default, headers: self.headers()).map({ value in
            
            guard let statistic = value as? [String: AnyObject] else {
                return [:]
            }
            
            return statistic
        })
    }
}

//MARK: - User

extension APIUnsplash {
    
    func getUserPhotos(_ per_page: Int, _ page: Int, _ userName: String) -> Observable<[[String: AnyObject]]> {
        
        return json(.get, URL.init(string: Urls.userPhotos(userName: userName, per_page: per_page, page: page).urlString())!, parameters: nil, encoding: URLEncoding.default, headers: self.headers()).map({ value in
            
            guard let photos = value as? [[String: AnyObject]] else {
                return []
            }
            
            self.dbManager.savePhotos(photos)
            
            return photos
            
        })
    }
}












