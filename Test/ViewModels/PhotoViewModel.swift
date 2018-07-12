//
//  PhotoViewModel.swift
//  Test
//
//  Created by v.sova on 11.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MagicalRecord

class PhotoViewModel {
    
    var photo = BehaviorRelay<Photo?>.init(value: nil)
    
    var statistics = BehaviorRelay<DetailsPhoto?>.init(value: nil)
    
    var image: UIImage?
    
    
    
    private let disposeBag = DisposeBag()
    
    private let dbManager: DBManager
    
    private let api: APIUnsplash
    
    init(_ value: Photo) {
        
        dbManager = DBManager()
        
        api = APIUnsplash(dbManager)
        
        photo.accept(value)
        
        dbManager.refreshed.filter{$0 == true}.subscribe(onNext: { (refreshed) in
            
            if let p = self.photo.value, let id = p.id {
                self.photo.accept(self.dbManager.getPhoto(id))
            }
            
        }).disposed(by: disposeBag)
        
//        self.photo.asObservable().subscribe(onNext: { (photo) in
//
//            guard let id = self.photo.value?.id else {
//
//                return
//            }
//
//            self.api.statisticsPhoto(id).map({ (value) in
//
//                self.statistics.accept(DetailsPhoto.init(value))
//
//            }).subscribe()
//                .disposed(by: self.disposeBag)
//
//        }).disposed(by: disposeBag)
    }
    
    func likeOrUnlike() {
        
        guard let id = self.photo.value?.id, let isLike = self.photo.value?.likedByUser else {
            return
        }
        if isLike {
            self.api.unlikePhoto(id).subscribe().disposed(by: self.disposeBag)
            
        } else {
            self.api.likePhoto(id).subscribe().disposed(by: self.disposeBag)
        }
    }
    
    func updateStatistics() {
        
        guard let id = self.photo.value?.id else {
            
            return
        }
        
        self.api.statisticsPhoto(id).map({ (value) in
            
            self.statistics.accept(DetailsPhoto.init(value))
            
        }).subscribe()
            .disposed(by: self.disposeBag)
    }
}
