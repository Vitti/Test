//
//  ViewModelUser.swift
//  Test
//
//  Created by v.sova on 09.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MagicalRecord

class UserViewModel {
    
    let disposeBag = DisposeBag()
    
    var api: APIUnsplash
    var dbManager: DBManager
    var accessToken = BehaviorRelay<String?>.init(value: nil)
    var user = BehaviorRelay<User?>.init(value: nil)
    
    init() {

        dbManager = DBManager()
        api = APIUnsplash.init(dbManager)
        user.accept(dbManager.getUser())
        
        dbManager.refreshed.filter{$0 == true}.subscribe(onNext: { (refreshed) in
            
                self.user.accept(self.dbManager.getUser())
        }).disposed(by: disposeBag)
        
        accessToken.asObservable().subscribe(onNext: { (token) in
            
            guard let t = token else {
                return
            }
            self.api.getUser(t).asObservable().subscribe(onNext: { dict in
      
            }).disposed(by: self.disposeBag)
            
        }, onError: { (error) in
            
        }).disposed(by: disposeBag)
        
        accessToken.accept(UserViewModel.getAccessToken())
    }
    
    func getAccessToken(_ code: String) -> Observable<String?> {
        
        return api.getToken(code).map({ value in
            
            guard let dict = value, let accessToken = dict["access_token"] as? String else {

                return nil
            }
            return accessToken
        })
    }

    class func saveAccessToken(_ token: String?) {
        
        guard let t = token else {
            UserDefaults.standard.removeObject(forKey: "access_token")
            return
        }
        
        UserDefaults.standard.set(t, forKey: "access_token")
    }
    
    class func getAccessToken() -> String? {
        
        return UserDefaults.standard.value(forKey: "access_token") as? String
    }
}
