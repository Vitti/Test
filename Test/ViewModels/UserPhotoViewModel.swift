//
//  MyPhotoViewModel.swift
//  Test
//
//  Created by v.sova on 12.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserPhotoViewModel {
    
    let user = BehaviorRelay<User?>.init(value: nil)
    
    let disposeBag = DisposeBag()
    
    var per_page = BehaviorRelay.init(value: 30)
    var page = BehaviorRelay.init(value: 1)
    var isRequestEnable = BehaviorRelay.init(value: false)
    var data = BehaviorRelay.init(value: [PhotoViewModel]())
    let api: APIUnsplash
    let dbManager: DBManager
    
    init(_ user: User) {
        
        dbManager = DBManager()
        api = APIUnsplash(dbManager)
        
        self.user.accept(user)
        
        dbManager.refreshed.filter{$0 == true}.asObservable().subscribe(onNext: { (refreshed) in
            
            guard let userName = self.user.value?.userName else {
                return
            }
            
            var array = [PhotoViewModel]()
            let photos = self.dbManager.getPhotosWith(userName)
            photos.forEach({ photo in
                
                let photoVM = PhotoViewModel.init(photo)
                array.append(photoVM)
            })
            self.data.accept(array)
            
        }).disposed(by: disposeBag)
        
        page.asObservable().debug().subscribe(onNext: { next in
            
            guard let userName = self.user.value?.userName else {
                return
            }
            
            self.isRequestEnable.accept(true)
            self.api.getUserPhotos(self.per_page.value, next, userName).debug().subscribe(onNext: { photos in
                self.isRequestEnable.accept(false)
            }).disposed(by: self.disposeBag)
            
        }).disposed(by: disposeBag)
    }
    
    func getNextPage() {
        
        if isRequestEnable.value {
            return
        }
        page.accept(page.value + 1)
    }
}
