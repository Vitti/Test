//
//  DBManager.swift
//  Test
//
//  Created by v.sova on 11.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//

import Foundation
import RxCocoa
import MagicalRecord

class DBManager {

    var refreshed = BehaviorRelay.init(value: true)

}

//MARK: - Photos

extension DBManager {
    
    private func createPhoto(_ id: String, _ data: [String: AnyObject], _ userName: String, _ context: NSManagedObjectContext) {
        
        let photo = Photo.mr_findFirstOrCreate(byAttribute: "id", withValue: id, in: context)
        
        photo.id = data["id"] as? String
        photo.name = data["description"] as? String
        photo.urlFull = data["urls"]?["full"] as? String
        photo.urlSmall = data["urls"]?["small"] as? String
        photo.width = data["width"] as? Int32 ?? 1
        photo.height = data["height"] as? Int32 ?? 1
        photo.likedByUser = data["liked_by_user"] as? Bool ?? false
        photo.updatedAt = (data["updated_at"] as? String ?? "").getDateInSec()
        photo.userName = userName
    }
    
    func savePhotos(_ value: [[String: AnyObject]]) {
        
        self.refreshed.accept(false)
        MagicalRecord.save({ (context) in
            
            value.forEach({ (dict) in
                
                if let id = dict["id"] as? String, let userName = dict["user"]?["username"] as? String {
                    
                    self.createPhoto(id, dict, userName, context)
                }
            })
            
        }) { (isSave, error) in
            
            self.refreshed.accept(true)
        }
    }
    
    func getPhotos(_ per_page: Int, _ page: Int) -> [Photo] {
        
        let request = Photo.mr_requestAll()
        request.fetchLimit = per_page * page
        request.sortDescriptors = [NSSortDescriptor.init(key: "updatedAt", ascending: false)]
        
        return (Photo.mr_executeFetchRequest(request) as? [Photo]) ?? []
    }
    
    func getPhoto(_ id: String) -> Photo? {
    
        return Photo.mr_findFirst(with: NSPredicate.init(format: "id == [c] %@", argumentArray: [id]))
    }
    
    func getPhotosWith(_ userName: String) -> [Photo] {
        
        let request = Photo.mr_requestAll()
        request.sortDescriptors = [NSSortDescriptor.init(key: "updatedAt", ascending: false)]
        request.predicate = NSPredicate.init(format: "userName == [c] %@", argumentArray: [userName])
        
        return (Photo.mr_executeFetchRequest(request) as? [Photo]) ?? []
    }
}

//MARK: - User

extension DBManager {
    
    func saveUser(_ userDict: [String: Any]) {
        
        refreshed.accept(false)
        MagicalRecord.save({ (context) in
            
            if let name = userDict["name"] as? String, let userName = userDict["username"] as? String {
                
                User.mr_truncateAll(in: context)
                
                let newUser = User.mr_createEntity(in: context)
                newUser?.name = name
                newUser?.userName = userName
                
                if let photos = userDict["photos"] as? [[String: AnyObject]] {
                    
                    photos.forEach({ (dict) in
                        
                        if let id = dict["id"] as? String {
                            
                            self.createPhoto(id, dict, userName, context)
                        }
                    })
                }
            }
            
        }) { (isSave, error) in
            
            self.refreshed.accept(true)
        }
    }
    
    func getUser() -> User? {
        
        return User.mr_findFirst()
    }
}























